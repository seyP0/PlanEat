import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var session: SessionManager

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
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            .padding(.horizontal)
            .padding(.top, -60)

            // MARK: – Menu Buttons
            VStack(spacing: 20) {
                MenuButton(icon: "pencil", title: "Edit Profile") { print("Edit Profile tapped") }
                MenuButton(icon: "lock", title: "Password") { print("Password tapped") }
                MenuButton(icon: "globe", title: "Language") { print("Language tapped") }
                MenuButton(icon: "questionmark.circle", title: "Support") { print("Support tapped") }
                MenuButton(icon: "arrow.forward.square", title: "Sign Out") {
                    session.signOut()
                }
            }
            .padding(.top, 50)
            .padding(.horizontal)
            .padding(.bottom, 40)

            Spacer()

            
        }
        .background(Color.white)
    }
}

private struct MenuButton: View {
    let icon: String
    let title: String
    var action: (() -> Void)?

    var body: some View {
        Button(action: {
            action?()
        }) {
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
        .padding()
        .background(Color(red: 0.43, green: 0.57, blue: 0.65))
        .cornerRadius(12)
    }
}


