import SwiftUI

struct MealView: View {
    var body: some View {
        VStack(spacing: 0) {
            
            // Top Navigation Bar
            HStack {
                Image(systemName: "chevron.left")
                Text("Home")
                    .font(.headline)
                Spacer()
            }
            .padding()
            
            Spacer().frame(height: 20)
            
            // One Blue Rectangle Meal Example
            HStack {
                Text("--")
                    .bold()
                Spacer()
                Text("--")
                Spacer()
                Text("--kcal")
                Spacer()
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
            .padding()
            .frame(height: 50)
            .background(Color(red: 117/255, green: 144/255, blue: 160/255))
            .cornerRadius(20)
            .foregroundColor(.white)
            .padding(.horizontal)
            
            Spacer().frame(height: 20)
            
            // MORE + Box with same size
            Button(action: {}) {
                Text("MORE +")
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 117/255, green: 144/255, blue: 160/255))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(red: 117/255, green: 144/255, blue: 160/255), lineWidth: 1)
                    )
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Tab Bar
            ZStack {
                CustomTabBarBackground()
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
                            .offset(x: 85, y: 15)
                        Image(systemName: "calendar")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                            .offset(x: -30, y: 45)
                    }
                    .offset(y: -40)
                    Spacer()
                    Image(systemName: "star")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .offset(x: -30, y: -25)
                    Spacer()
                    Image(systemName: "person")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .offset(x: -5, y: 3)
                    Spacer()
                }
            }
        }
        .padding(.top, 30)
        .padding(.bottom, 30)
        .frame(width: 393, height: 852)
        .background(Color.white)
    }
}

struct CustomTabBarBackground: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height + 40
        let cornerRadius: CGFloat = 16
        let notchRadius: CGFloat = 65
        let centerX = width / 2 + 45
        let notchDepth: CGFloat = 20

        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        path.addQuadCurve(to: CGPoint(x: cornerRadius, y: 0), control: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: centerX - notchRadius - 40, y: 0))
        path.addQuadCurve(
            to: CGPoint(x: centerX - notchRadius, y: notchDepth * 1.5),
            control: CGPoint(x: centerX - notchRadius + 0.5, y: 0)
        )
        path.addArc(
            center: CGPoint(x: centerX, y: notchDepth),
            radius: notchRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: true
        )
        path.addQuadCurve(
            to: CGPoint(x: centerX + notchRadius + 30, y: 0),
            control: CGPoint(x: centerX + notchRadius + 1, y: 0)
        )
        path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
        path.addQuadCurve(to: CGPoint(x: width, y: cornerRadius), control: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height))
        path.closeSubpath()

        return path
    }
}

struct MealView_Previews: PreviewProvider {
    static var previews: some View {
        MealView()
    }
}
