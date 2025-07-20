import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(spacing: 0) {
            // MARK: – Header Card
            VStack {
                HStack(spacing: 8) {
                    Button(action: {
                        // your back action
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .medium))
                            Text("Home")
                                .font(.headline)
                        }
                        .foregroundColor(Color(red: 0.43, green: 0.57, blue: 0.65))
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 50)

                // Profile Image + Add Button
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Circle()
                                .stroke(Color(red: 0.84, green: 0.84, blue: 0.84), lineWidth: 1)
                        )

                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 30, height: 30)
                            .shadow(radius: 1)
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(red: 0.43, green: 0.57, blue: 0.65))
                    }
                    .offset(x: 6, y: 6)
                }
                .padding(.top, 15)

                Text("--")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.43, green: 0.57, blue: 0.65))
                    .padding(.top, 12)

                Text("--")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
            }
            .frame(width: 400, height: 300)
            .foregroundColor(.clear)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            .padding(.horizontal)
            .padding(.top, -60)

            // MARK: – Menu Buttons
            VStack(spacing: 20) {
                MenuButton(icon: "pencil", title: "Edit Profile")
                MenuButton(icon: "lock", title: "Password")
                MenuButton(icon: "globe", title: "Language")
                MenuButton(icon: "questionmark.circle", title: "Support")
                MenuButton(icon: "arrow.forward.square", title: "Sign Out") {
    session.signOut()
}
            }
            .padding(.top, 50)
            .padding(.horizontal)
            .padding(.bottom, 40)

            Spacer()

            // MARK: – Tab Bar
            ZStack {
                CustomTab()
                    .fill(Color(red: 0.43, green: 0.57, blue: 0.65))
                    .frame(width: 480, height: 80)
                    .edgesIgnoringSafeArea(.bottom)

                HStack {
                    Spacer()
                    Image(systemName: "house")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .offset(x: 10, y: 6)
                    Spacer()

                    ZStack {
                        Circle()
                            .fill(Color(red: 0.25, green: 0.37, blue: 0.44))
                            .frame(width: 95, height: 95)
                            .shadow(color: .black.opacity(0.6), radius: 3, x: 0, y: 4)
                            .offset(x: 165, y: 15)

                        Image(systemName: "calendar")
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                            .offset(x: -26, y: 47)
                    }
                    .offset(y: -40)
                    Spacer()

                    Image(systemName: "star")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .offset(x: -65, y: 6)
                    Spacer()

                    Image(systemName: "person")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .offset(x: -43, y: -25)
                    Spacer()
                }
            }
        }
        .background(Color.white)
    }
}

private struct MenuButton: View {
    let icon: String
    let title: String
    var action: (() -> Void)?

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: 28)

            Text(title)
                .foregroundColor(.white)
                .font(.headline)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.white)
        }
        .padding()
        .background(Color(red: 0.43, green: 0.57, blue: 0.65))
        .cornerRadius(12)
    }
}

struct CustomTab: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height + 40
        let cornerRadius: CGFloat = 16
        let notchRadius: CGFloat = 65
        let centerX = width / 2 + 125
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
