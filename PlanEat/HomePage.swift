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

                // Pass emoji image & tap handler
                SnackImageSection(
                    snackText: snackRecommendation,
                    emojiImageName: moodImageName
                ) {
                    withAnimation { showMoodPopup = true }
                }

                NutrientSummary()
                DynamicWeeklyCalendar()
                MealsSection()
                Spacer()
            }
            .padding(.top)
            .background(.white)
            .ignoresSafeArea(edges: .bottom)
            .onAppear { fetchUserName() }

            // Overlay popup
            if showMoodPopup {
                FirstPopUp(
                    selectedMoodFace: $selectedMoodFace,
                    selectedMoodLabel: $selectedMoodLabel
                ) {
                    withAnimation { showMoodPopup = false }
                }
            }
        }
    }

    func fetchUserName() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No user logged in.")
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
                return
            }
            if let document = document, document.exists {
                let data = document.data()
                self.userName = data?["name"] as? String ?? "User"
            } else {
                print("User document does not exist.")
            }
        }
    }
}

struct HeaderSection: View {
    let userName: String

    var body: some View {
        HStack {
            Image("smile 10") // keep your original asset
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
        path.addLine(to: CGPoint(x: rect.minX , y: rect.minY + 10 + yOffset))
        path.addLine(to: CGPoint(x: rect.minX - 5, y: rect.maxY + 5 + yOffset))
        path.closeSubpath()
        return path
    }
}

// ===== UPDATED to support mood emoji tap =====
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

struct MealsSection: View {
    @State private var meals: [Meal] = [
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
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(meals.indices, id: \.self) { idx in
                    MealCard(
                        title: meals[idx].title,
                        caloriesRange: meals[idx].caloriesRange,
                        items: meals[idx].items,
                        imageName: meals[idx].imageName,
                        isFavorite: $meals[idx].isFavorite
                    )
                    .frame(width: 160)
                }
            }
            .padding(.horizontal)
        }
    }
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


struct HomePage_previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
