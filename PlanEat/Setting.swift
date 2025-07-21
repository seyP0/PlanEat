import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SettingsView: View {
    @EnvironmentObject var session: SessionManager
    @State private var displayName = ""
    @State private var displayEmail = ""

    @State private var showLogoutPopup = false
    @State private var logoutSelection: LogoutChoice? = nil
    private enum LogoutChoice { case yes, no }

    var body: some View {
        NavigationStack {
            ZStack {
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

                        Text(displayName)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 0.43, green: 0.57, blue: 0.65))
                            .padding(.top, 12)

                        Text(displayEmail)
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
                        // **Edit Profile** now pushes to EditProfileView
                        NavigationLink(destination: EditProfileView()) {
    HStack {
        Image(systemName: "pencil")
            .font(.system(size: 20))
            .foregroundColor(.white)
            .frame(width: 28)

        Text("Edit Profile")
            .foregroundColor(.white)
            .font(.headline)

        Spacer()

        Image(systemName: "chevron.right")
            .foregroundColor(.white)
    }
    .padding()
    .frame(width: 350)
    .background(Color(red: 0.43, green: 0.57, blue: 0.65))
    .cornerRadius(12)
}

                        MenuButton(icon: "lock", title: "Password") { print("Password tapped") }
                        MenuButton(icon: "globe", title: "Language") { print("Language tapped") }
                        MenuButton(icon: "questionmark.circle", title: "Support") { print("Support tapped") }

                        // **Sign Out** shows the popup
                        MenuButton(icon: "arrow.forward.square", title: "Sign Out") {
                            showLogoutPopup = true
                            logoutSelection = nil
                        }
                    }
                    .padding(.top, 50)
                    .padding(.horizontal)
                    .padding(.bottom, 40)

                    Spacer()
                }
                .background(Color.white)
                .onAppear {
                    if let user = Auth.auth().currentUser {
                        displayEmail = user.email ?? ""
                        Firestore.firestore()
                            .collection("users")
                            .document(user.uid)
                            .getDocument { snapshot, _ in
                                if let data = snapshot?.data(),
                                   let name = data["name"] as? String {
                                    displayName = name
                                }
                            }
                    }
                }

                // MARK: – Logout Confirmation Overlay
                if showLogoutPopup {
                    Color.black.opacity(0.4).ignoresSafeArea()

                    VStack(spacing: 16) {
                        Text("Are you sure? 🥲")
                            .font(.custom("Baloo Bhaijaan 2", size: 18))
                            .bold()

                        HStack(spacing: 20) {
                            Button("Yes") {
                                logoutSelection = .yes
                                session.signOut()
                                showLogoutPopup = false
                            }
                            .buttonStyle(PillButtonStyle(isSelected: logoutSelection == .yes))

                            Button("No") {
                                logoutSelection = .no
                                showLogoutPopup = false
                            }
                            .buttonStyle(PillButtonStyle(isSelected: logoutSelection == .no))
                        }
                    }
                    .padding(24)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 4)
                }
            }
        }
    }
}

// Reusable menu button
private struct MenuButton: View {
    let icon: String
    let title: String
    var action: (() -> Void)?

    var body: some View {
        Button(action: { action?() }) {
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
            .frame(width: 350)
            .background(Color(red: 0.43, green: 0.57, blue: 0.65))
            .cornerRadius(12)
        }
    }
}

// Pill-style button for the popup
struct PillButtonStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("Baloo Bhaijaan 2", size: 14))
            .frame(width: 80, height: 36)
            .background(isSelected
                        ? Color(red: 0.43, green: 0.57, blue: 0.65)
                        : Color.white)
            .foregroundColor(isSelected
                             ? .white
                             : Color(red: 0.43, green: 0.57, blue: 0.65))
            .overlay(RoundedRectangle(cornerRadius: 18)
                        .stroke(Color(red: 0.43, green: 0.57, blue: 0.65), lineWidth: 1))
            .cornerRadius(18)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
