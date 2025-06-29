import SwiftUI

struct HomePage: View {
    @State private var userName = "Jonathan Lee"
    @State private var snackRecommendation = "Try Greek Berries Yogurt!"
    @State private var selectedDate = 5

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HeaderSection(userName: userName)
            SnackImageSection(snackText: snackRecommendation)
            NutrientSummary()
            DatePickerSection(selectedDate: $selectedDate)
            MealsSection()
            Spacer()
            BottomNavigationBar()
        }
        .padding(.top)
        .background(.white)
        .ignoresSafeArea(edges: .bottom)
    }
}

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
        path.addLine(to: CGPoint(x: rect.minX , y: rect.minY + 10 + yOffset))
        path.addLine(to: CGPoint(x: rect.minX - 5, y: rect.maxY + 5 + yOffset))
        path.closeSubpath()
        return path
    }
}


struct SnackImageSection: View {
    var snackText: String

    var body: some View {
        VStack(alignment: .leading) {
            Text("Today's recommended snack:")
                .font(
                Font.custom("Baloo Bhaijaan 2", size: 13)
                .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.51, green: 0.6, blue: 0.62))
                .frame(width: 179, height: 22, alignment: .top)
            HStack(alignment: .center, spacing: 10) {
                Image("smile-2")
                    .resizable()
                    .frame(width: 65, height: 65)
                
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
                            .font(Font.custom("Baloo Bhaijaan 2", size: 16)
                            .weight(.bold)
                            )
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
            Spacer(minLength: 0) // Pushes the full content to the right

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
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, maxHeight: 20, alignment: .init(horizontal: .center, vertical: .bottom))
                        
                        Text("\nkcal")
                            .foregroundColor(.white)
                            .font(Font.custom("Baloo Bhaijaan 2", size: 15))
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: 110, height: 80)
                }
                .padding(.horizontal)
            }
        }
        .padding(.horizontal)
    }
}


struct DatePickerSection: View {
    @Binding var selectedDate: Int

    var body: some View {
        
        ZStack {
            Rectangle()
                .frame(width: 350, height: 90)
                .foregroundColor(.white)
                .cornerRadius(20)
            VStack(spacing: 8) {
                Text("May 2025")
                    .font(Font.custom("Baloo Bhaijaan 2", size: 20).weight(.bold))
                    .foregroundColor(.black)
                HStack(spacing: 20) {
                    ForEach(2...8, id: \ .self) { day in
                        VStack {
                            Text(["S", "M", "T", "W", "T", "F", "S"][day - 2])
                                .font(.caption)
                            Text("0\(day)")
                                .font(.headline)
                                .padding(6)
                                .background(selectedDate == day ? Color(red: 0.27, green: 0.45, blue: 0.54) : Color.clear)
                                .foregroundColor(selectedDate == day ? .white : .primary)
                                .clipShape(Circle())
                        }.onTapGesture { selectedDate = day }
                    }
                }
                
            }.padding(.horizontal)
        }
    }
}

struct MealsSection: View {
    var body: some View {
        HStack(spacing: 16) {
            MealCard(title: "Breakfast", items: ["A cup of milk", "Avocado Egg Toast"], imageName: "breakfast")
            MealCard(title: "Lunch", items: ["Chicken Salad", "Whole Grain Bread"], imageName: "lunch")
            MealCard(title: "Dinner", items: ["Grilled Salmon", "Roasted Vegetables"], imageName: "dinner")
        }.padding(.horizontal)
    }
}

struct MealCard: View {
    var title: String
    var items: [String]
    var imageName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            Text("400–450 kcal")
                .font(.caption)
                .foregroundColor(.gray)
            Image(imageName)
                .resizable()
                .scaledToFit()
                .cornerRadius(12)
            ForEach(items, id: \.self) { item in
                Text("• " + item)
                    .font(.caption)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(18)
        .shadow(radius: 2)
    }
}

struct BottomNavigationBar: View {
    var body: some View {
        // Tab Bar
        ZStack {
            CustomTabBarShape()
                .fill(Color(red: 0.43, green: 0.57, blue: 0.65))
                .frame(width: 450, height: 90)
                .edgesIgnoringSafeArea(.bottom)

            HStack {
                Spacer()
                Image(systemName: "house")
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                    .offset(x: 1, y: 3)
                Spacer()
                ZStack {
                    Circle()
                        .fill(Color(red: 0.25, green: 0.37, blue: 0.44))
                        .frame(width: 95, height: 95)
                        .shadow(color: .black.opacity(0.6), radius: 3, x: 0, y: 4)
                        .offset(x: -1, y: 15)
                    Image(systemName: "calendar")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                        .offset(x: -1, y: 12)
                }
                .offset(y: -40)
                Spacer()
                Image(systemName: "star")
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                    .offset(x: 2, y: 3)
                Spacer()
                Image(systemName: "person")
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                    .offset(x: -1, y: 3)
                Spacer()
            }
        }
        .padding(.top, 30)
        .frame(width: 393, height: 852)
        .background(Color.white)
    }
}

struct CustomTabBarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height + 40
        let cornerRadius: CGFloat = 16
        let notchRadius: CGFloat = 65
        let centerX = width / 2 - 40
        let notchDepth: CGFloat = 20// how far the notch cuts down

        // Start from bottom-left
        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        path.addQuadCurve(to: CGPoint(x: cornerRadius, y: 0), control: CGPoint(x: 0, y: 0))

        // Left edge before notch
        path.addLine(to: CGPoint(x: centerX - notchRadius - 40, y: 0))
        path.addQuadCurve(
            to: CGPoint(x: centerX - notchRadius, y: notchDepth * 1.5),
            control: CGPoint(x: centerX - notchRadius + 0.5, y: 0)
        )

        // Arc cutting downward for notch
        path.addArc(
            center: CGPoint(x: centerX, y: notchDepth),
            radius: notchRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: true
        )

        // Right edge after notch
//        path.addQuadCurve(
//            to: CGPoint(x: centerX + notchRadius + 20, y: notchDepth / 20),
//            control: CGPoint(x: centerX + notchRadius , y: notchDepth / 60 )
//        )
        path.addQuadCurve(
            to: CGPoint(x: centerX + notchRadius + 30, y: 0),
            control: CGPoint(x: centerX + notchRadius + 1, y: 0)
        )


        path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
        path.addQuadCurve(to: CGPoint(x: width, y: cornerRadius), control: CGPoint(x: width, y: 0))

        // Close bottom
        path.addLine(to: CGPoint(x: width, y: height))
        path.closeSubpath()

        return path
    }
}

struct HomePage_previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}


