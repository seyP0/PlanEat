import Foundation
import SwiftUI

// Provide your OpenAI API Key by adding a string key OPENAI_API_KEY in your target's Info.plist.

// MARK: - Data Models
struct AIMeal: Identifiable, Codable {
    let id = UUID()
    let name: String
    let description: String
    let calories: String
    let ingredients: [String]
    let mealType: String // breakfast, lunch, dinner, snack
    var imageURL: String?
    var isFavorite: Bool = false

    enum CodingKeys: String, CodingKey {
        case name, description, calories, ingredients, mealType, imageURL, isFavorite
    }
}

// MARK: - AI Service
class AIService: ObservableObject {
    static let shared = AIService()

    @Published var generatedMeals: [AIMeal] = []
    @Published var recommendedSnackText: String = "Try some Fresh Fruit & Nuts!"
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var imageGenerationStatus: [String: String] = [:] // Track image generation status

    // Cache for generated images to avoid regenerating
    private var imageCache: [String: UIImage] = [:]

    private let openAIAPIKey: String = {
        // Try common variants to avoid case/key mismatches
        let keys = ["OPENAI_API_KEY", "openai_api_key"]
        for k in keys {
            if let v = Bundle.main.object(forInfoDictionaryKey: k) as? String, !v.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return v.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        return ""
    }()
    private let openAIBaseURL = "https://api.openai.com/v1"

    private init() {
        print("AIService: OPENAI_API_KEY present:", !openAIAPIKey.isEmpty)
    }

    // MARK: - Snack Recommendation (existing functionality)
    func recommendSnack(forMood mood: String, completion: @escaping (String) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.requestSnackFromOpenAI(forMood: mood) { snack in
                DispatchQueue.main.async {
                    let text = snack ?? self.getMoodBasedSnackRecommendation(mood: mood)
                    self.recommendedSnackText = text
                    completion(text)
                }
            }
        }
    }

    // MARK: - Real snack recommendation via OpenAI
    private func requestSnackFromOpenAI(forMood mood: String, completion: @escaping (String?) -> Void) {
        guard !openAIAPIKey.isEmpty, let url = URL(string: "\(openAIBaseURL)/chat/completions") else {
            print("AIService: requestSnackFromOpenAI guard failed. Key present:", !openAIAPIKey.isEmpty)
            completion(nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(openAIAPIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 20

        print("AIService: requestSnackFromOpenAI usingRealAPI:", !openAIAPIKey.isEmpty, "mood:", mood)

        let prompt = "Suggest one concise healthy snack for someone feeling \(mood). Respond with a short phrase only."
        let body: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [
                ["role": "system", "content": "You are a nutritionist. Reply with a concise snack suggestion only."],
                ["role": "user", "content": prompt]
            ],
            "max_tokens": 60,
            "temperature": 0.7
        ]

        do { request.httpBody = try JSONSerialization.data(withJSONObject: body) } catch { completion(nil); return }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("AIService: Snack request network error:", error.localizedDescription)
                completion(nil)
                return
            }
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let choices = json["choices"] as? [[String: Any]],
                  let first = choices.first,
                  let message = first["message"] as? [String: Any],
                  let content = message["content"] as? String else {
                if let data = data, let body = String(data: data, encoding: .utf8) {
                    print("AIService: Snack response body:", body)
                }
                completion(nil)
                return
            }
            completion(content.trimmingCharacters(in: .whitespacesAndNewlines))
        }.resume()
    }

    // MARK: - Generate AI Meals Based on Mood
    func generateMealsForMood(_ mood: String, completion: @escaping ([AIMeal]) -> Void) {
        print("AIService: generateMealsForMood called with mood:", mood, "usingRealAPI:", !openAIAPIKey.isEmpty)
        isLoading = true
        errorMessage = nil

        // Clear image generation state so images refresh when mood changes
        self.imageGenerationStatus.removeAll()
        self.imageCache.removeAll()

        // Choose between real API call or mock data
        // Set USE_REAL_API to true when you want to use actual OpenAI API
        let USE_REAL_API = true // Change to true for real API calls

        if USE_REAL_API && !openAIAPIKey.isEmpty {
            callOpenAIForMeals(mood: mood) { meals in
                DispatchQueue.main.async {
                    self.generatedMeals = meals
                    self.generateImagesForMeals(meals)
                    self.isLoading = false
                    self.errorMessage = nil
                    completion(meals)
                }
            }
        } else {
            // Use mock data for development
            DispatchQueue.global(qos: .userInitiated).async {
                let meals = self.getMoodBasedMeals(mood: mood)

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.generatedMeals = meals
                    self.generateImagesForMeals(meals)
                    self.isLoading = false
                    completion(meals)
                }
            }
        }
    }

    private func generateImagesForMeals(_ meals: [AIMeal]) {
        for meal in meals {
            self.generateMealImage(for: meal) { _ in }
        }
    }

    // MARK: - Generate Real AI Meal Image
    func generateMealImage(for meal: AIMeal, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = "\(meal.name)_\(meal.mealType)"

        // Check cache first
        if let cachedImage = imageCache[cacheKey] {
            completion(cachedImage)
            return
        }

        // Update status
        DispatchQueue.main.async {
            self.imageGenerationStatus[meal.id.uuidString] = "Generating..."
        }

        // Set USE_REAL_IMAGE_API to true when you want real AI image generation
        let USE_REAL_IMAGE_API = true // Change to true for real API calls

        if USE_REAL_IMAGE_API && !openAIAPIKey.isEmpty {
            print("AIService: generateMealImage using REAL image API for", meal.name)
            generateRealAIImage(for: meal) { image in
                DispatchQueue.main.async {
                    if let image = image {
                        self.imageCache[cacheKey] = image
                        self.imageGenerationStatus[meal.id.uuidString] = "Generated"
                    } else {
                        self.imageGenerationStatus[meal.id.uuidString] = "Failed"
                    }
                    completion(image)
                }
            }
        } else {
            print("AIService: generateMealImage using MOCK image for", meal.name)
            // Use enhanced placeholder for development
            DispatchQueue.global(qos: .userInitiated).async {
                let placeholderImage = self.createRealisticFoodImage(for: meal)

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    if let image = placeholderImage {
                        self.imageCache[cacheKey] = image
                        self.imageGenerationStatus[meal.id.uuidString] = "Generated (Mock)"
                    }
                    completion(placeholderImage)
                }
            }
        }
    }

    // MARK: - Real AI Image Generation with DALL-E
    private func generateRealAIImage(for meal: AIMeal, completion: @escaping (UIImage?) -> Void) {
        let prompt = createImagePrompt(for: meal)

        generateImageWithDALLE(prompt: prompt) { imageURL in
            guard let imageURL = imageURL else {
                print("Failed to generate image URL for meal: \(meal.name) | prompt: \(prompt)")
                completion(nil)
                return
            }

            // Download the generated image
            self.downloadImage(from: imageURL) { image in
                completion(image)
            }
        }
    }

    // MARK: - Create Optimized Image Prompt
    private func createImagePrompt(for meal: AIMeal) -> String {
        let ingredientsList = meal.ingredients.joined(separator: ", ")
        let moodContext = getMoodContext(from: meal.name)

        let basePrompt = """
        A professional, appetizing photo of \(meal.name.lowercased()).
        The dish contains: \(ingredientsList).
        \(moodContext)
        Shot with natural lighting, shallow depth of field, restaurant quality presentation.
        Clean white background or wooden table.
        High resolution, food photography style, Instagram worthy.
        No text or watermarks.
        """

        return basePrompt
    }

    // MARK: - Get Mood Context for Image Prompt
    private func getMoodContext(from mealName: String) -> String {
        let name = mealName.lowercased()

        if name.contains("cooling") || name.contains("zen") || name.contains("calming") {
            return "The presentation should look fresh, clean, and calming with cool colors."
        } else if name.contains("sunshine") || name.contains("celebration") || name.contains("rainbow") {
            return "The presentation should look vibrant, colorful, and joyful with warm lighting."
        } else if name.contains("comfort") || name.contains("cozy") || name.contains("healing") {
            return "The presentation should look warm, comforting, and homestyle with soft lighting."
        } else if name.contains("energy") || name.contains("power") || name.contains("boost") {
            return "The presentation should look energizing and fresh with bright, vibrant colors."
        } else if name.contains("gentle") || name.contains("light") || name.contains("digestive") {
            return "The presentation should look light, clean, and gentle with soft, natural colors."
        } else if name.contains("brain") || name.contains("focus") || name.contains("memory") {
            return "The presentation should look sophisticated and nutritious with rich, deep colors."
        }

        return "The presentation should look balanced, healthy, and appetizing."
    }

    // MARK: - Download Image from URL
    private func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("Invalid response or status code")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }

            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
        }

        task.resume()
    }

    // MARK: - Enhanced Realistic Food Images (Fallback)
    private func createRealisticFoodImage(for meal: AIMeal) -> UIImage? {
        let size = CGSize(width: 320, height: 200)
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { context in
            // Create realistic gradient background
            let colors = getRealisticFoodColors(for: meal)

            // Create radial gradient for more depth
            if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                       colors: [colors.primary.cgColor, colors.secondary.cgColor, colors.accent.cgColor] as CFArray,
                                       locations: [0.0, 0.6, 1.0]) {

                context.cgContext.drawRadialGradient(
                    gradient,
                    startCenter: CGPoint(x: size.width * 0.4, y: size.height * 0.3),
                    startRadius: 20,
                    endCenter: CGPoint(x: size.width * 0.6, y: size.height * 0.7),
                    endRadius: size.width * 0.8,
                    options: [.drawsBeforeStartLocation, .drawsAfterEndLocation]
                )
            }

            // Add realistic food elements
            drawRealisticFoodElements(context: context.cgContext, size: size, meal: meal)

            // Add subtle texture overlay
            addFoodTexture(context: context.cgContext, size: size)

            // Add professional overlay with meal info
            addProfessionalOverlay(context: context.cgContext, size: size, meal: meal)
        }
    }

//    // MARK: - Create Realistic Food Images (REPLACE createMockAIImage WITH THIS)
//    private func createRealisticFoodImage(for meal: AIMeal) -> UIImage? {
//        let size = CGSize(width: 320, height: 200)
//        let renderer = UIGraphicsImageRenderer(size: size)
//
//        return renderer.image { context in
//            // Create realistic gradient background
//            let colors = getRealisticFoodColors(for: meal)
//
//            // Create radial gradient for more depth
//            if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
//                                       colors: [colors.primary.cgColor, colors.secondary.cgColor, colors.accent.cgColor] as CFArray,
//                                       locations: [0.0, 0.6, 1.0]) {
//
//                context.cgContext.drawRadialGradient(
//                    gradient,
//                    startCenter: CGPoint(x: size.width * 0.4, y: size.height * 0.3),
//                    startRadius: 20,
//                    endCenter: CGPoint(x: size.width * 0.6, y: size.height * 0.7),
//                    endRadius: size.width * 0.8,
//                    options: [.drawsBeforeStartLocation, .drawsAfterEndLocation]
//                )
//            }
//
//            // Add realistic food elements
//            drawRealisticFoodElements(context: context.cgContext, size: size, meal: meal)
//
//            // Add subtle texture overlay
//            addFoodTexture(context: context.cgContext, size: size)
//
//            // Add professional overlay with meal info
//            addProfessionalOverlay(context: context.cgContext, size: size, meal: meal)
//        }
//    }

    // MARK: - ADD THESE NEW HELPER FUNCTIONS
    private func getRealisticFoodColors(for meal: AIMeal) -> (primary: UIColor, secondary: UIColor, accent: UIColor) {
        let name = meal.name.lowercased()
        let ingredients = meal.ingredients.joined(separator: " ").lowercased()

        // Color based on specific ingredients
        if ingredients.contains("salmon") || name.contains("salmon") {
            return (
                primary: UIColor(red: 0.95, green: 0.7, blue: 0.6, alpha: 1.0),
                secondary: UIColor(red: 0.9, green: 0.5, blue: 0.4, alpha: 1.0),
                accent: UIColor(red: 0.8, green: 0.3, blue: 0.2, alpha: 1.0)
            )
        } else if ingredients.contains("avocado") || name.contains("avocado") {
            return (
                primary: UIColor(red: 0.7, green: 0.85, blue: 0.4, alpha: 1.0),
                secondary: UIColor(red: 0.5, green: 0.7, blue: 0.3, alpha: 1.0),
                accent: UIColor(red: 0.3, green: 0.5, blue: 0.2, alpha: 1.0)
            )
        } else if ingredients.contains("berry") || ingredients.contains("blueberry") || name.contains("berry") {
            return (
                primary: UIColor(red: 0.8, green: 0.4, blue: 0.7, alpha: 1.0),
                secondary: UIColor(red: 0.6, green: 0.2, blue: 0.5, alpha: 1.0),
                accent: UIColor(red: 0.4, green: 0.1, blue: 0.3, alpha: 1.0)
            )
        } else if ingredients.contains("green") || name.contains("green") || ingredients.contains("spinach") {
            return (
                primary: UIColor(red: 0.4, green: 0.8, blue: 0.5, alpha: 1.0),
                secondary: UIColor(red: 0.3, green: 0.6, blue: 0.4, alpha: 1.0),
                accent: UIColor(red: 0.2, green: 0.4, blue: 0.3, alpha: 1.0)
            )
        } else if ingredients.contains("oat") || name.contains("oat") || ingredients.contains("grain") {
            return (
                primary: UIColor(red: 0.9, green: 0.8, blue: 0.6, alpha: 1.0),
                secondary: UIColor(red: 0.8, green: 0.7, blue: 0.5, alpha: 1.0),
                accent: UIColor(red: 0.7, green: 0.6, blue: 0.4, alpha: 1.0)
            )
        } else if ingredients.contains("chocolate") || name.contains("chocolate") {
            return (
                primary: UIColor(red: 0.5, green: 0.3, blue: 0.2, alpha: 1.0),
                secondary: UIColor(red: 0.4, green: 0.2, blue: 0.1, alpha: 1.0),
                accent: UIColor(red: 0.3, green: 0.1, blue: 0.05, alpha: 1.0)
            )
        }

        // Default colors based on meal type
        switch meal.mealType.lowercased() {
        case "breakfast":
            return (
                primary: UIColor(red: 1.0, green: 0.85, blue: 0.4, alpha: 1.0),
                secondary: UIColor(red: 0.95, green: 0.7, blue: 0.3, alpha: 1.0),
                accent: UIColor(red: 0.9, green: 0.6, blue: 0.2, alpha: 1.0)
            )
        case "lunch":
            return (
                primary: UIColor(red: 0.5, green: 0.8, blue: 0.5, alpha: 1.0),
                secondary: UIColor(red: 0.4, green: 0.7, blue: 0.4, alpha: 1.0),
                accent: UIColor(red: 0.3, green: 0.6, blue: 0.3, alpha: 1.0)
            )
        case "dinner":
            return (
                primary: UIColor(red: 0.8, green: 0.6, blue: 0.4, alpha: 1.0),
                secondary: UIColor(red: 0.7, green: 0.5, blue: 0.3, alpha: 1.0),
                accent: UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0)
            )
        default:
            return (
                primary: UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0),
                secondary: UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0),
                accent: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
            )
        }
    }

    private func drawRealisticFoodElements(context: CGContext, size: CGSize, meal: AIMeal) {
        let ingredients = meal.ingredients.joined(separator: " ").lowercased()

        context.setBlendMode(.overlay)
        context.setFillColor(UIColor.white.withAlphaComponent(0.4).cgColor)

        // Draw ingredient-specific shapes
        if ingredients.contains("berry") || ingredients.contains("fruit") {
            // Draw berries
            for i in 0..<8 {
                let x = 40 + CGFloat(i * 30) + CGFloat.random(in: -10...10)
                let y = 60 + CGFloat(i % 3 * 20) + CGFloat.random(in: -5...5)
                let size = CGFloat.random(in: 8...15)
                context.fillEllipse(in: CGRect(x: x, y: y, width: size, height: size))
            }
        }

        if ingredients.contains("avocado") {
            // Draw avocado shape
            let avocadoPath = CGMutablePath()
            avocadoPath.addEllipse(in: CGRect(x: 120, y: 70, width: 35, height: 50))
            context.addPath(avocadoPath)
            context.fillPath()
        }

        if ingredients.contains("salmon") || ingredients.contains("fish") {
            // Draw fish fillet shape
            let fishPath = CGMutablePath()
            fishPath.move(to: CGPoint(x: 180, y: 90))
            fishPath.addCurve(to: CGPoint(x: 250, y: 100),
                             control1: CGPoint(x: 210, y: 80),
                             control2: CGPoint(x: 230, y: 85))
            fishPath.addCurve(to: CGPoint(x: 180, y: 130),
                             control1: CGPoint(x: 230, y: 115),
                             control2: CGPoint(x: 210, y: 120))
            fishPath.closeSubpath()
            context.addPath(fishPath)
            context.fillPath()
        }

        if ingredients.contains("egg") {
            // Draw egg shape
            context.fillEllipse(in: CGRect(x: 80, y: 75, width: 30, height: 40))
        }

        if ingredients.contains("grain") || ingredients.contains("oat") || ingredients.contains("rice") {
            // Draw grain texture
            for _ in 0..<20 {
                let x = CGFloat.random(in: 20...size.width-20)
                let y = CGFloat.random(in: 40...size.height-40)
                context.fillEllipse(in: CGRect(x: x, y: y, width: 3, height: 6))
            }
        }

        context.setBlendMode(.normal)
    }

    private func addFoodTexture(context: CGContext, size: CGSize) {
        // Add subtle texture overlay
        context.setBlendMode(.softLight)
        context.setFillColor(UIColor.white.withAlphaComponent(0.1).cgColor)

        // Create organic texture pattern
        for _ in 0..<50 {
            let x = CGFloat.random(in: 0...size.width)
            let y = CGFloat.random(in: 0...size.height)
            let dotSize = CGFloat.random(in: 1...3)
            context.fillEllipse(in: CGRect(x: x, y: y, width: dotSize, height: dotSize))
        }

        context.setBlendMode(.normal)
    }

    private func addProfessionalOverlay(context: CGContext, size: CGSize, meal: AIMeal) {
        // Add gradient overlay at bottom for text
        let overlayHeight: CGFloat = 60
        let overlayRect = CGRect(x: 0, y: size.height - overlayHeight, width: size.width, height: overlayHeight)

        // Create gradient for overlay
        if let overlayGradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                          colors: [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.8).cgColor] as CFArray,
                                          locations: [0.0, 1.0]) {
            context.drawLinearGradient(overlayGradient,
                                     start: CGPoint(x: 0, y: size.height - overlayHeight),
                                     end: CGPoint(x: 0, y: size.height),
                                     options: [])
        }

        // Add meal name
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .bold),
            .foregroundColor: UIColor.white,
            .strokeColor: UIColor.black.withAlphaComponent(0.3),
            .strokeWidth: -1
        ]

        let title = meal.name
        let titleSize = title.size(withAttributes: titleAttributes)
        title.draw(in: CGRect(
            x: 16,
            y: size.height - 45,
            width: min(titleSize.width, size.width - 70),
            height: titleSize.height
        ), withAttributes: titleAttributes)

        // Add calories
        let calorieAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13, weight: .medium),
            .foregroundColor: UIColor.white.withAlphaComponent(0.9)
        ]

        meal.calories.draw(in: CGRect(
            x: 16,
            y: size.height - 22,
            width: 120,
            height: 15
        ), withAttributes: calorieAttributes)

        // Add AI generation badge
        let badgeRect = CGRect(x: size.width - 55, y: size.height - 45, width: 45, height: 20)
        context.setFillColor(UIColor.systemBlue.withAlphaComponent(0.9).cgColor)
        context.fillEllipse(in: badgeRect)

        let badgeAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11, weight: .bold),
            .foregroundColor: UIColor.white
        ]

        "AI Gen".draw(in: CGRect(
            x: badgeRect.origin.x + 8,
            y: badgeRect.origin.y + 5,
            width: 35,
            height: 12
        ), withAttributes: badgeAttributes)

        // Add sparkle effect for AI generation
        context.setFillColor(UIColor.white.withAlphaComponent(0.8).cgColor)
        let sparklePositions = [
            CGPoint(x: 25, y: 25),
            CGPoint(x: size.width - 30, y: 30),
            CGPoint(x: 40, y: size.height - 80)
        ]

        for position in sparklePositions {
            // Draw simple sparkle
            context.fillEllipse(in: CGRect(x: position.x - 2, y: position.y - 2, width: 4, height: 4))
            context.fill(CGRect(x: position.x - 1, y: position.y - 6, width: 2, height: 12))
            context.fill(CGRect(x: position.x - 6, y: position.y - 1, width: 12, height: 2))
        }
    }

    // MARK: - Private Helper Methods
    private func getMoodBasedSnackRecommendation(mood: String) -> String {
        switch mood.lowercased() {
        case "happy":
            return "Try Greek Berries Yogurt!"
        case "sad", "down":
            return "How about some Dark Chocolate & Almonds?"
        case "angry", "irritated":
            return "Cool down with Cucumber Water & Hummus!"
        case "drained", "heavy":
            return "Energize with a Green Smoothie!"
        case "bloated":
            return "Settle with Ginger Tea & Crackers!"
        case "foggy":
            return "Sharpen up with Blueberry & Walnut Mix!"
        default:
            return "Try some Fresh Fruit & Nuts!"
        }
    }

    private func getMoodBasedMeals(mood: String) -> [AIMeal] {
        switch mood.lowercased() {
        case "happy":
            return [
                AIMeal(
                    name: "Sunshine Pancakes",
                    description: "Fluffy pancakes with fresh berries and honey",
                    calories: "420-450 kcal",
                    ingredients: ["Whole wheat flour", "Fresh berries", "Greek yogurt", "Honey"],
                    mealType: "breakfast"
                ),
                AIMeal(
                    name: "Rainbow Buddha Bowl",
                    description: "Colorful veggie bowl with quinoa and tahini dressing",
                    calories: "380-420 kcal",
                    ingredients: ["Quinoa", "Roasted vegetables", "Chickpeas", "Tahini dressing"],
                    mealType: "lunch"
                ),
                AIMeal(
                    name: "Celebration Salmon",
                    description: "Herb-crusted salmon with roasted sweet potatoes",
                    calories: "450-500 kcal",
                    ingredients: ["Atlantic salmon", "Sweet potatoes", "Fresh herbs", "Olive oil"],
                    mealType: "dinner"
                )
            ]

        case "sad", "down":
            return [
                AIMeal(
                    name: "Comfort Oatmeal",
                    description: "Warm cinnamon oatmeal with banana and walnuts",
                    calories: "350-400 kcal",
                    ingredients: ["Steel-cut oats", "Banana", "Walnuts", "Cinnamon"],
                    mealType: "breakfast"
                ),
                AIMeal(
                    name: "Healing Soup",
                    description: "Nourishing chicken and vegetable soup",
                    calories: "300-350 kcal",
                    ingredients: ["Chicken broth", "Mixed vegetables", "Brown rice", "Fresh herbs"],
                    mealType: "lunch"
                ),
                AIMeal(
                    name: "Cozy Mac & Cheese",
                    description: "Healthier version with cauliflower and real cheese",
                    calories: "400-450 kcal",
                    ingredients: ["Whole grain pasta", "Cauliflower", "Sharp cheddar", "Almond milk"],
                    mealType: "dinner"
                )
            ]

        case "angry", "irritated":
            return [
                AIMeal(
                    name: "Cooling Green Smoothie",
                    description: "Refreshing spinach and cucumber smoothie",
                    calories: "250-300 kcal",
                    ingredients: ["Fresh spinach", "Cucumber", "Green apple", "Coconut water"],
                    mealType: "breakfast"
                ),
                AIMeal(
                    name: "Zen Garden Salad",
                    description: "Light salad with cooling ingredients",
                    calories: "320-370 kcal",
                    ingredients: ["Mixed greens", "Cucumber", "Mint", "Lemon vinaigrette"],
                    mealType: "lunch"
                ),
                AIMeal(
                    name: "Calming Herb Fish",
                    description: "Gentle white fish with soothing herbs",
                    calories: "380-430 kcal",
                    ingredients: ["White fish", "Dill", "Parsley", "Steamed vegetables"],
                    mealType: "dinner"
                )
            ]

        case "drained", "heavy":
            return [
                AIMeal(
                    name: "Energy Boost Bowl",
                    description: "Power-packed acai bowl with superfoods",
                    calories: "400-450 kcal",
                    ingredients: ["Acai berries", "Granola", "Chia seeds", "Fresh fruit"],
                    mealType: "breakfast"
                ),
                AIMeal(
                    name: "Revitalizing Wrap",
                    description: "Turkey and avocado wrap with fresh veggies",
                    calories: "380-420 kcal",
                    ingredients: ["Whole wheat tortilla", "Turkey breast", "Avocado", "Sprouts"],
                    mealType: "lunch"
                ),
                AIMeal(
                    name: "Power Protein Bowl",
                    description: "Quinoa bowl with grilled chicken and vegetables",
                    calories: "450-500 kcal",
                    ingredients: ["Quinoa", "Grilled chicken", "Roasted vegetables", "Pesto"],
                    mealType: "dinner"
                )
            ]

        case "bloated":
            return [
                AIMeal(
                    name: "Gentle Ginger Porridge",
                    description: "Soothing oat porridge with digestive spices",
                    calories: "300-350 kcal",
                    ingredients: ["Oats", "Ginger", "Turmeric", "Coconut milk"],
                    mealType: "breakfast"
                ),
                AIMeal(
                    name: "Light Broth Bowl",
                    description: "Clear vegetable broth with gentle ingredients",
                    calories: "250-300 kcal",
                    ingredients: ["Vegetable broth", "Rice noodles", "Ginger", "Scallions"],
                    mealType: "lunch"
                ),
                AIMeal(
                    name: "Digestive Tea Salmon",
                    description: "Simply prepared salmon with fennel",
                    calories: "350-400 kcal",
                    ingredients: ["Wild salmon", "Fennel", "Lemon", "Digestive herbs"],
                    mealType: "dinner"
                )
            ]

        case "foggy":
            return [
                AIMeal(
                    name: "Brain Boost Smoothie",
                    description: "Blueberry and walnut smoothie for mental clarity",
                    calories: "350-400 kcal",
                    ingredients: ["Blueberries", "Walnuts", "Greek yogurt", "Spinach"],
                    mealType: "breakfast"
                ),
                AIMeal(
                    name: "Focus Fish Tacos",
                    description: "Omega-3 rich fish tacos with avocado",
                    calories: "400-450 kcal",
                    ingredients: ["White fish", "Corn tortillas", "Avocado", "Cabbage slaw"],
                    mealType: "lunch"
                ),
                AIMeal(
                    name: "Memory Meal",
                    description: "Salmon with brain-boosting vegetables",
                    calories: "450-500 kcal",
                    ingredients: ["Salmon", "Broccoli", "Sweet potato", "Olive oil"],
                    mealType: "dinner"
                )
            ]

        default: // neutral or unknown mood
            return [
                AIMeal(
                    name: "Balanced Breakfast",
                    description: "Perfect balance of protein, carbs, and healthy fats",
                    calories: "380-420 kcal",
                    ingredients: ["Eggs", "Avocado toast", "Mixed berries", "Greek yogurt"],
                    mealType: "breakfast"
                ),
                AIMeal(
                    name: "Harmony Bowl",
                    description: "Well-balanced lunch with all food groups",
                    calories: "400-450 kcal",
                    ingredients: ["Brown rice", "Grilled protein", "Mixed vegetables", "Tahini"],
                    mealType: "lunch"
                ),
                AIMeal(
                    name: "Complete Dinner",
                    description: "Nutritionally complete dinner plate",
                    calories: "450-500 kcal",
                    ingredients: ["Lean protein", "Whole grains", "Seasonal vegetables", "Healthy fats"],
                    mealType: "dinner"
                )
            ]
        }
    }

    private func getMockImageName(for mealType: String) -> String {
        // Return image names that should exist in your assets
        switch mealType.lowercased() {
        case "breakfast":
            return "breakfast"
        case "lunch":
            return "lunch"
        case "dinner":
            return "dinner"
        default:
            return "meal_placeholder"
        }
    }
}

// MARK: - Real OpenAI Integration (commented out for demo)

extension AIService {
    private func callOpenAIForMeals(mood: String, completion: @escaping ([AIMeal]) -> Void) {
        guard let url = URL(string: "\(openAIBaseURL)/chat/completions") else {
            print("Invalid URL")
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Invalid URL"
                completion([])
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(openAIAPIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30.0

        let prompt = """
        Based on the user's mood: \(mood), suggest 3 healthy meals (breakfast, lunch, dinner) that would be appropriate for someone feeling \(mood).

        Consider nutritional and psychological benefits. For each meal, provide:
        - A creative, mood-appropriate name
        - A brief, appetizing description (1-2 sentences)
        - Calorie range (like "400-450 kcal")
        - 3-4 main ingredients

        Return ONLY a valid JSON array with this exact structure:
        [
          {
            "name": "Creative Meal Name",
            "description": "Brief appetizing description",
            "calories": "400-450 kcal",
            "ingredients": ["ingredient1", "ingredient2", "ingredient3", "ingredient4"],
            "mealType": "breakfast"
          },
          {
            "name": "Creative Meal Name",
            "description": "Brief appetizing description",
            "calories": "380-420 kcal",
            "ingredients": ["ingredient1", "ingredient2", "ingredient3", "ingredient4"],
            "mealType": "lunch"
          },
          {
            "name": "Creative Meal Name",
            "description": "Brief appetizing description",
            "calories": "450-500 kcal",
            "ingredients": ["ingredient1", "ingredient2", "ingredient3", "ingredient4"],
            "mealType": "dinner"
          }
        ]
        """

        let body: [String: Any] = [
            "model": "gpt-4o-mini", // Use the more cost-effective model
            "messages": [
                [
                    "role": "system",
                    "content": "You are a nutritionist and chef who creates personalized meal recommendations based on mood and emotional state. Always respond with valid JSON only."
                ],
                [
                    "role": "user",
                    "content": prompt
                ]
            ],
            "max_tokens": 1500,
            "temperature": 0.7
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("Error creating request body: \(error)")
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Error creating request body"
                completion([])
            }
            return
        }

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else {
                completion([])
                return
            }
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    completion([])
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response type")
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "Invalid response type"
                    completion([])
                }
                return
            }

            guard httpResponse.statusCode == 200 else {
                print("HTTP Error: \(httpResponse.statusCode)")
                if let data = data, let errorString = String(data: data, encoding: .utf8) {
                    print("Error details: \(errorString)")
                }
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "API Error: \(httpResponse.statusCode)"
                    completion([])
                }
                return
            }

            guard let data = data else {
                print("No data received")
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "No data received"
                    completion([])
                }
                return
            }

            if let body = String(data: data, encoding: .utf8) {
                print("AIService: Meals raw body:", body)
            }

            do {
                guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let choices = json["choices"] as? [[String: Any]],
                      let firstChoice = choices.first,
                      let message = firstChoice["message"] as? [String: Any],
                      let content = message["content"] as? String else {
                    print("Invalid JSON structure")
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.errorMessage = "Invalid JSON structure"
                        completion([])
                    }
                    return
                }

                print("OpenAI Response: \(content)")

                // Clean the content to ensure it's valid JSON
                let cleanedContent = self.cleanJSONString(content)

                // Parse the JSON response into AIMeal objects
                if let mealsData = cleanedContent.data(using: .utf8) {
                    let decoder = JSONDecoder()
                    do {
                        let meals = try decoder.decode([AIMeal].self, from: mealsData)
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.errorMessage = nil
                            completion(meals)
                        }
                    } catch {
                        print("JSON decoding error: \(error)")
                        // Fallback to mock data if parsing fails
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.errorMessage = "JSON decoding error: \(error.localizedDescription)"
                            completion(self.getMoodBasedMeals(mood: mood))
                        }
                    }
                } else {
                    print("Could not convert content to data")
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.errorMessage = "Invalid content data"
                        completion([])
                    }
                }

            } catch {
                print("JSON parsing error: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "JSON parsing error"
                    completion([])
                }
            }
        }.resume()
    }
    // MARK: - Clean JSON String Helper
    private func cleanJSONString(_ jsonString: String) -> String {
        // Remove any markdown code block markers
        var cleaned = jsonString
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        // Find the first '[' and last ']' to extract just the JSON array
        if let startIndex = cleaned.firstIndex(of: "["),
           let endIndex = cleaned.lastIndex(of: "]") {
            cleaned = String(cleaned[startIndex...endIndex])
        }

        return cleaned
    }

    // MARK: - FIXED DALL-E Image Generation

    private func generateImageWithDALLE(prompt: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "\(openAIBaseURL)/images/generations") else {
            print("Invalid image generation URL")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(openAIAPIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 60.0 // Images take longer to generate

        print("AIService: generateImageWithDALLE called (real):", !openAIAPIKey.isEmpty)

        let body: [String: Any] = [
            "model": "dall-e-3",
            "prompt": prompt,
            "n": 1,
            "size": "1024x1024",
            "quality": "standard",
            "response_format": "url"
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("Error creating image request body: \(error)")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Image generation network error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid image response type")
                completion(nil)
                return
            }

            guard httpResponse.statusCode == 200 else {
                print("Image HTTP Error: \(httpResponse.statusCode)")
                if let data = data, let errorString = String(data: data, encoding: .utf8) {
                    print("Image error details: \(errorString)")
                }
                print("AIService: Image HTTP status:", httpResponse.statusCode)
                completion(nil)
                return
            }

            guard let data = data else {
                print("No image data received")
                completion(nil)
                return
            }

            do {
                guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let dataArray = json["data"] as? [[String: Any]],
                      let firstImage = dataArray.first,
                      let imageURL = firstImage["url"] as? String else {
                    print("Invalid image JSON structure")
                    completion(nil)
                    return
                }

                print("Generated image URL: \(imageURL)")
                DispatchQueue.main.async {
                    completion(imageURL)
                }

            } catch {
                print("Image JSON parsing error: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
