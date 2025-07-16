import SwiftUI
import FirebaseAuth

struct LogIn: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggedIn = false

    var body: some View {
                VStack(spacing: 30) {
                    Spacer()

                    // Logo
                    Image("FullLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 241.26923, height: 220)

                    // Email + Password Fields
                    VStack(spacing: 19) {
                        TextField("Email", text: $email)
                            .font(Font.custom("Baloo Bhaijaan 2", size: 14))
                            .kerning(0.28)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(Color.white)
                            .cornerRadius(17)
                            .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 4)

                        SecureField("Password", text: $password)
                            .font(Font.custom("Baloo Bhaijaan 2", size: 14))
                            .kerning(0.28)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(Color.white)
                            .cornerRadius(17)
                            .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 4)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 50)

                    // Navigation to MainView after login
                    NavigationLink(destination: MainView(), isActive: $isLoggedIn) {
                        EmptyView()
                    }

                    // Sign In Button
                    Button(action: {
                        Auth.auth().signIn(withEmail: email, password: password) { result, error in
                            if let error = error {
                                print("Login failed:", error.localizedDescription)
                            } else {
                                print("Login success! UID:", result?.user.uid ?? "")
                                isLoggedIn = true
                            }
                        }
                    }) {
                        Text("Sign In")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .font(Font.custom("Baloo Bhaijaan 2", size: 14))
                            .kerning(0.28)
                            .background(Color(red: 0.43, green: 0.57, blue: 0.65))
                            .foregroundColor(.white)
                            .cornerRadius(17)
                            .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 4)
                    }
                    .padding(.horizontal, 50)

                    // OR Divider
                    HStack {
                        Rectangle().frame(width: 70, height: 1).foregroundColor(.black)
                        Text("or")
                            .font(Font.custom("Baloo Bhaijaan 2", size: 12))
                            .foregroundColor(.black)
                        Rectangle().frame(width: 70, height: 1).foregroundColor(.black)
                    }
                    .padding(.horizontal, 32)

                    // Social Buttons
                    HStack(spacing: 24) {
                        Button(action: {}) {
                            ZStack {
                                Rectangle()
                                    .frame(width: 64, height: 64)
                                    .foregroundColor(.white)
                                    .cornerRadius(17)
                                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)

                                Image("Google")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32, height: 32)
                            }
                        }

                        Button(action: {}) {
                            ZStack {
                                Rectangle()
                                    .frame(width: 64, height: 64)
                                    .foregroundColor(.white)
                                    .cornerRadius(17)
                                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)

                                Image("Apple")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32, height: 32)
                            }
                        }
                    }

                    // Sign Up and Forgot Password
                    VStack(spacing: 8) {
                        HStack(spacing: 0) {
                            Text("Don’t have an account?")
                                .font(Font.custom("ABeeZee", size: 10))
                                .foregroundColor(.black)

                            NavigationLink(destination: SignUp()) {
                                Text("Sign Up")
                                    .font(Font.custom("ABeeZee", size: 10))
                                    .underline(true, pattern: .solid)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.49, green: 0.63, blue: 0.66))
                                    .frame(width: 40, height: 19, alignment: .top)
                                    .offset(x: -3)
                            }
                        }

                        NavigationLink(destination: ForgotPasswordView()) {
                            Text("Forgot Password?")
                                .font(Font.custom("ABeeZee", size: 10))
                                .underline()
                                .foregroundColor(Color(red: 0.49, green: 0.63, blue: 0.66))
                        }
                    }
                    .padding(.top, 8)

                    Spacer()
                }
    }
                .padding(.top)
                .background(
                    RoundedCorner(radius: 900, corners: [.topLeft, .topRight])
                        .fill(Color(red: 0.89, green: 0.96, blue: 0.97))
                        .edgesIgnoringSafeArea(.bottom)
                        .offset(y: 200)
                )
                .navigationBarHidden(true)
            }



struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct LogIn_Previews: PreviewProvider {
    static var previews: some View {
        LogIn()
            .previewDevice("iPhone 16")
    }
}
