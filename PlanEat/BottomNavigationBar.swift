import SwiftUI

struct BottomNavigationBar: View {
    @Binding var selectedTab: Tab

    var body: some View {
        ZStack {
            CustomTabBarShape()
                .fill(Color(red: 0.43, green: 0.57, blue: 0.65))
                .frame(height: 90)
                .edgesIgnoringSafeArea(.bottom)

            HStack(spacing: 0) {
                TabButton(icon: "house.fill", tab: .home)
                TabButton(icon: "calendar", tab: .calendar)
                TabButton(icon: "star", tab: .favorites)
                TabButton(icon: "person", tab: .profile)
            }
            .padding(.horizontal, 20)

            Circle()
                .fill(Color(red: 0.25, green: 0.37, blue: 0.44))
                .frame(width: 95, height: 95)
                .shadow(color: .black.opacity(0.6), radius: 3, x: 0, y: 4)
                .overlay(
                    Image(systemName: selectedTabIcon)
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                )
                .offset(x: -UIScreen.main.bounds.width / 2 + 67, y: -25)
        }
        .frame(height: 90)
    }

    var selectedTabIcon: String {
        switch selectedTab {
        case .home: return "house.fill"
        case .calendar: return "calendar"
        case .favorites: return "star"
        case .profile: return "person"
        }
    }

    func TabButton(icon: String, tab: Tab) -> some View {
        VStack {
            Spacer()
            Button {
                selectedTab = tab
            } label: {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 25))
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

struct CustomTabBarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height + 40
        let cornerRadius: CGFloat = 0
        let notchRadius: CGFloat = 55
        let centerX = width / 2 - 130
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
        path.addLine(to: CGPoint(x: width - 16, y: 0))
        path.addQuadCurve(to: CGPoint(x: width, y: 16), control: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height))
        path.closeSubpath()

        return path
    }
}
