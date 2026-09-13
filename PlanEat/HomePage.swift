import SwiftUI
import FirebaseFirestore
import FirebaseAuth


struct HomePage: View {
    @State private var userName = ""
    @State private var snackRecommendation = "Try Greek Berries Yogurt!"
    @State private var selectedDate = 5

    // === Mood feature states ===
    @State private var showMoodPopup = false
    @State private var selectedMoodFace: String? = nil
    @State private var selectedMoodLabel: String? = nil

    // === AI Integration states ===
    @StateObject private var aiService = AIService.shared
    @State private var aiGeneratedMeals: [AIMeal] = []
    @State private var isGeneratingMeals = false

    private let db = Firestore.firestore()

    /// today's document key (e.g. "2025-07-23")
     private var todayKey: String {
         let f = DateFormatter()
         f.dateFormat = "yyyy-MM-dd"
         return f.string(from: Date())
     }


    /// Map the selection to your actual asset name
    private var moodImageName: String {
        switch selectedMoodFace {
        case "Happy":   return "smile"
        case "Neutral": return "neutral"
        case "Sad":     return "sad"
        case "Angry":   return "angry"
        default:        return "smile" // fallback / initial
        }
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                HeaderSection(userName: userName)

                // → now tappable for mood
                SnackImageSection(
                    snackText: snackRecommendation,
                    emojiImageName: moodImageName
                ) {
                    withAnimation { showMoodPopup = true }
                }

                NutrientSummary()
                DynamicWeeklyCalendar()

                // Updated MealsSection with AI integration
                AIMealsSection(
                    aiMeals: aiGeneratedMeals,
                    isLoading: isGeneratingMeals,
                    currentMood: selectedMoodLabel ?? "Neutral"
                )

                Spacer()
            }
            .padding(.top)
            .background(.white)
            .ignoresSafeArea(edges: .bottom)
            .onAppear {
                fetchUserName()
                loadMoodAndRecommend()
            }

            // Overlay your existing first pop-up
            if showMoodPopup {
                FirstPopUp(
                    selectedMoodFace: $selectedMoodFace,
                    selectedMoodLabel: $selectedMoodLabel
                ) {
                    // onDismiss
                    withAnimation { showMoodPopup = false }
                    if let mood = selectedMoodLabel {
                        writeMoodAndRecommend(moodLabel: mood)
                        generateAIMeals(for: mood)
                    }
                }
            }
        }
    }

    // MARK: — unchanged
    func fetchUserName() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).getDocument { doc, err in
            if let d = doc?.data(), let name = d["name"] as? String {
                self.userName = name
            }
        }
    }

    // MARK: — 1) read Firestore → 2) call AI → 3) display & save
    func loadMoodAndRecommend() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = db
            .collection("users")
            .document(uid)
            .collection("moods")
            .document(todayKey)

        ref.getDocument { snap, _ in
            // default to neutral if no doc
            let mood = snap?.data()?["mood"] as? String ?? "neutral"
            self.selectedMoodLabel = mood.capitalized

            // Load existing AI meals if available
            if let mealsData = snap?.data()?["aiMeals"] as? Data,
               let savedMeals = try? JSONDecoder().decode([AIMeal].self, from: mealsData) {
                self.aiGeneratedMeals = savedMeals
            } else {
                // Generate new meals if none exist
                self.generateAIMeals(for: mood)
            }

            // now ask AI for snack recommendation
            AIService.shared.recommendSnack(forMood: mood) { rec in
                self.snackRecommendation = rec
                // write recommendation back
                ref.setData([
                    "mood": mood,
                    "recommendation": rec,
                    "timestamp": Timestamp()
                ], merge: true)
            }
        }
    }

    // MARK: — when user taps "Done" on pop-up
    func writeMoodAndRecommend(moodLabel: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let moodKey = moodLabel.lowercased()
        let ref = db
            .collection("users")
            .document(uid)
            .collection("moods")
            .document(todayKey)

        // 1) save mood
        ref.setData([
            "mood": moodKey,
            "timestamp": Timestamp()
        ], merge: true)

        // 2) ask AI for snack
        AIService.shared.recommendSnack(forMood: moodKey) { rec in
            self.snackRecommendation = rec
            // 3) save recommendation
            ref.setData([
                "recommendation": rec
            ], merge: true)
        }
    }

    // MARK: — Generate AI meals based on mood
    func generateAIMeals(for mood: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        isGeneratingMeals = true

        AIService.shared.generateMealsForMood(mood) { meals in
            self.aiGeneratedMeals = meals
            self.isGeneratingMeals = false

            // Save generated meals to Firestore
            let ref = self.db
                .collection("users")
                .document(uid)
                .collection("moods")
                .document(self.todayKey)

            if let mealsData = try? JSONEncoder().encode(meals) {
                ref.setData([
                    "aiMeals": mealsData
                ], merge: true)
            }
        }
    }
}

// MARK: — AI-Enhanced Meals Section
struct AIMealsSection: View {
    let aiMeals: [AIMeal]
    let isLoading: Bool
    let currentMood: String

    // Fallback meals (your original ones)
    @State private var fallbackMeals: [Meal] = [
        Meal(title: "Breakfast",
             caloriesRange: "400–450 kcal",
             items: ["A cup of milk", "Avocado Egg Toast"],
             imageName: "breakfast"),
        Meal(title: "Lunch",
             caloriesRange: "400–450 kcal",
             items: ["Chicken Salad", "Whole Grain Bread"],
             imageName: "lunch"),
        Meal(title: "Dinner",
             caloriesRange: "400–450 kcal",
             items: ["Grilled Salmon", "Roasted Vegetables"],
             imageName: "dinner")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Meals for your mood")
                    .font(.custom("Baloo Bhaijaan 2", size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.43, green: 0.57, blue: 0.65))

                Spacer()

                if !currentMood.isEmpty {
                    Text("Feeling \(currentMood.lowercased())")
                        .font(.custom("Baloo Bhaijaan 2", size: 12))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)

            if isLoading {
                // Loading state
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(0..<3, id: \.self) { _ in
                            LoadingMealCard()
                                .frame(width: 160)
                        }
                    }
                    .padding(.horizontal)
                }
            } else if !aiMeals.isEmpty {
                // AI-generated meals
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(aiMeals) { meal in
                            AIMealCard(meal: meal)
                                .frame(width: 160)
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                // Fallback to original meals
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(fallbackMeals.indices, id: \.self) { idx in
                            MealCard(
                                title: fallbackMeals[idx].title,
                                caloriesRange: fallbackMeals[idx].caloriesRange,
                                items: fallbackMeals[idx].items,
                                imageName: fallbackMeals[idx].imageName,
                                isFavorite: $fallbackMeals[idx].isFavorite
                            )
                            .frame(width: 160)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

// MARK: — AI Meal Card Component
struct AIMealCard: View {
    let meal: AIMeal
    @State private var isFavorite: Bool = false
    @State private var generatedImage: UIImage?
    @State private var isLoadingImage = true

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 1) {
                HStack {
                    Text(meal.mealType.capitalized)
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                    Button {
                        isFavorite.toggle()
                    } label: {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .foregroundColor(isFavorite ? .yellow : .gray)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
                .frame(height: 22)

                Text(meal.calories)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, -2)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .frame(height: 45)
            .background(Color.white)

            // AI-generated meal image
            ZStack {
                if let image = generatedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 80)
                        .clipped()
                } else {
                    // Loading state with AI generation indicator
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 80)

                        if isLoadingImage {
                            VStack(spacing: 4) {
                                Image(systemName: "sparkles")
                                    .foregroundColor(Color(red: 0.43, green: 0.57, blue: 0.65))
                                    .font(.system(size: 16))
                                Text("AI Generating...")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        } else {
                            VStack(spacing: 4) {
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                                Text("Image unavailable")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(meal.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)

                ForEach(meal.ingredients.prefix(2), id: \.self) { ingredient in
                    Text("• \(ingredient)")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                }
            }
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.43, green: 0.57, blue: 0.65))
            .frame(height: 50)
        }
        .frame(width: 160)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color(red: 0.43, green: 0.57, blue: 0.65), lineWidth: 2)
                .allowsHitTesting(false)
        )
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.clear)
                .allowsHitTesting(false)
        )
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .onAppear {
            // Generate AI image for the meal
            AIService.shared.generateMealImage(for: meal) { image in
                self.generatedImage = image
                self.isLoadingImage = false
            }
            self.isFavorite = meal.isFavorite
        }
    }
}

// MARK: — Loading Meal Card Component
struct LoadingMealCard: View {
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 1) {
                HStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 60, height: 12)
                        .cornerRadius(6)
                    Spacer()
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 20, height: 20)
                        .cornerRadius(10)
                }
                .frame(height: 22)

                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 8)
                    .cornerRadius(4)
                    .padding(.top, -2)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .frame(height: 45)
            .background(Color.white)

            // Loading image placeholder
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 80)

                VStack(spacing: 4) {
                    Image(systemName: "sparkles")
                        .foregroundColor(Color(red: 0.43, green: 0.57, blue: 0.65))
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .animation(Animation.easeInOut(duration: 1.0).repeatForever(), value: isAnimating)
                    Text("Generating...")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(height: 10)
                    .cornerRadius(5)

                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(height: 8)
                    .cornerRadius(4)

                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(height: 8)
                    .cornerRadius(4)
            }
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.43, green: 0.57, blue: 0.65))
            .frame(height: 50)
        }
        .frame(width: 160)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color(red: 0.43, green: 0.57, blue: 0.65), lineWidth: 2)
                .allowsHitTesting(false)
        )
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.clear)
                .allowsHitTesting(false)
        )
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: — everything below here is literally your original code —

struct HeaderSection: View {
    let userName: String

    var body: some View {
        HStack {
            Image("smile 10")
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .padding(.leading)

            VStack(alignment: .leading) {
                Text("Good afternoon!")
                    .foregroundColor(.gray)
                    .font(.custom("Baloo Bhaijaan 2", size: 15))
                    .offset(y: 10)
                Text(userName)
                    .font(.custom("Baloo Bhaijaan 2", size: 25))
                    .bold()
                    .foregroundColor(Color(red: 0.43, green: 0.57, blue: 0.65))
            }
            Spacer()
            Button(action: {}) {
                Image(systemName: "line.3.horizontal")
                    .padding()
                    .background(Color(red: 0.63, green: 0.75, blue: 0.82))
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
            .padding(.trailing)
        }
        .offset(y: -6)
        .frame(width: 393, height: 70)
        .background(.white)
        .cornerRadius(30)
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
    }
}

struct BubbleTail: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let yOffset: CGFloat = 5
        path.move(to: CGPoint(x: rect.maxX + 5, y: rect.midY + yOffset))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + 10 + yOffset))
        path.addLine(to: CGPoint(x: rect.minX - 5, y: rect.maxY + 5 + yOffset))
        path.closeSubpath()
        return path
    }
}

struct SnackImageSection: View {
    var snackText: String
    let emojiImageName: String
    var onEmojiTap: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text("Today's recommended snack:")
                .font(Font.custom("Baloo Bhaijaan 2", size: 13).weight(.bold))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.51, green: 0.6, blue: 0.62))
                .frame(width: 179, height: 22, alignment: .top)

            HStack(alignment: .center, spacing: 10) {
                Button(action: onEmojiTap) {
                    Image(emojiImageName)
                        .resizable()
                        .frame(width: 65, height: 65)
                }
                .buttonStyle(PlainButtonStyle())

                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.25, green: 0.37, blue: 0.44))
                        .frame(width: 280, height: 50)
                        .shadow(radius: 2)

                    HStack(spacing: 0) {
                        BubbleTail()
                            .fill(Color(red: 0.25, green: 0.37, blue: 0.44))
                            .frame(width: 20, height: 20)
                            .rotationEffect(.degrees(180))
                            .offset(x: -10)
                        Text(snackText)
                            .font(Font.custom("Baloo Bhaijaan 2", size: 16).weight(.bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .frame(width: 231, height: 22, alignment: .top)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .offset(x: 10)
            }
        }
        .padding(.horizontal)
    }
}

struct NutrientSummary: View {
    var body: some View {
        HStack {
            Spacer(minLength: 0)

            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(red: 0.43, green: 0.57, blue: 0.65))
                    .frame(height: 120)

                HStack(spacing: 20) {
                    VStack {
                        Text("110g")
                            .font(Font.custom("Baloo Bhaijaan 2", size: 20).weight(.bold))
                            .foregroundColor(.white)
                        Text("Protein")
                            .font(Font.custom("Baloo Bhaijaan 2", size: 11))
                            .foregroundColor(.white)
                    }
                    VStack {
                        Text("50g")
                            .font(Font.custom("Baloo Bhaijaan 2", size: 20).weight(.bold))
                            .foregroundColor(.white)
                        Text("Fat")
                            .font(Font.custom("Baloo Bhaijaan 2", size: 11))
                            .foregroundColor(.white)
                    }
                    VStack {
                        Text("110g")
                            .font(Font.custom("Baloo Bhaijaan 2", size: 20).weight(.bold))
                            .foregroundColor(.white)
                        Text("Carbs")
                            .font(Font.custom("Baloo Bhaijaan 2", size: 11))
                            .foregroundColor(.white)
                    }
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 10)
                            .opacity(0.2)
                            .foregroundColor(.white)
                        Circle()
                            .trim(from: 0, to: 0.75)
                            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .foregroundColor(.white)
                            .rotationEffect(.degrees(-90))
                        Text("1300")
                            .foregroundColor(.white)
                            .font(Font.custom("Baloo Bhaijaan 2", size: 20).weight(.bold))
                        Text("\nkcal")
                            .foregroundColor(.white)
                            .font(Font.custom("Baloo Bhaijaan 2", size: 15))
                    }
                    .frame(width: 110, height: 80)
                }
                .padding(.horizontal)
            }
        }
        .padding(.horizontal)
    }
}

struct DynamicWeeklyCalendar: View {
    @State private var selectedDate = Date()
    private let calendar = Calendar.current
    private let today = Date()

    private static let monthYearFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMMM yyyy"
        return df
    }()
    private static let dayFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd"
        return df
    }()
    private let weekdaySymbols = Calendar.current.veryShortWeekdaySymbols

    private var monthYearString: String {
        DynamicWeeklyCalendar.monthYearFormatter.string(from: today)
    }

    private var startOfWeek: Date {
        calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
    }

    private var weekDates: [Date] {
        (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }

    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Button { } label: { Image(systemName: "chevron.left") }
                Spacer()
                Text(monthYearString)
                    .font(.custom("Baloo Bhaijaan 2", size: 16))
                    .fontWeight(.semibold)
                Spacer()
                Button { } label: { Image(systemName: "chevron.right") }
            }
            .font(.custom("Baloo Bhaijaan 2", size: 14))
            .foregroundColor(Color(red: 0.43, green: 0.57, blue: 0.65))

            HStack(spacing: 0) {
                ForEach(0..<7) { idx in
                    Text(weekdaySymbols[idx])
                        .frame(maxWidth: .infinity)
                        .font(.custom("Baloo Bhaijaan 2", size: 14))
                        .foregroundColor(.gray)
                }
            }

            HStack(spacing: 0) {
                ForEach(weekDates, id: \.self) { date in
                    let dayString = DynamicWeeklyCalendar.dayFormatter.string(from: date)
                    let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)

                    Button {
                        selectedDate = date
                    } label: {
                        Text(dayString)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .font(.custom("Baloo Bhaijaan 2", size: 16))
                            .fontWeight(.medium)
                            .foregroundColor(isSelected ? .white : .primary)
                            .background(
                                ZStack {
                                    if isSelected {
                                        Circle()
                                            .fill(Color(red: 0.43, green: 0.57, blue: 0.65))
                                            .frame(width: 40, height: 40)
                                        Circle()
                                            .stroke(Color(red: 0.43, green: 0.57, blue: 0.65), lineWidth: 2)
                                            .frame(width: 40, height: 40)
                                    }
                                }
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 16)
    }
}

struct Meal: Identifiable {
    let id = UUID()
    let title: String
    let caloriesRange: String
    let items: [String]
    let imageName: String?
    var isFavorite: Bool = false
}

struct MealCard: View {
    let title: String
    let caloriesRange: String
    let items: [String]
    let imageName: String?
    @Binding var isFavorite: Bool

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 1) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                    Button {
                        isFavorite.toggle()
                    } label: {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .foregroundColor(isFavorite ? .yellow : .gray)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
                .frame(height: 22)

                Text(caloriesRange)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, -2)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .frame(height: 45)
            .background(Color.white)

            if let name = imageName {
                Image(name)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 80)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 80)
            }

            VStack(alignment: .leading, spacing: 4) {
                ForEach(items, id: \.self) { item in
                    Text("• \(item)")
                        .font(.caption)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
            }
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.43, green: 0.57, blue: 0.65))
            .frame(height: 50)
        }
        .frame(width: 160)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color(red: 0.43, green: 0.57, blue: 0.65), lineWidth: 2)
                .allowsHitTesting(false)
        )
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.clear)
                .allowsHitTesting(false)
        )
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
