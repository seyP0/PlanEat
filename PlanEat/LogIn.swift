import SwiftUI
import FirebaseAuth

struct LogIn: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // Logo
            Image("FullLogo")
                .resizable()
                .scaledToFit()
                .multilineTextAlignment(.center)
                .frame(width: 241.26923, height: 220, alignment: .top)


            // Email + Password Fields
            VStack(spacing: 19) {
                TextField("Email", text: $email)
                    .font(Font.custom("Baloo Bhaijaan 2", size: 14))
                    .kerning(0.28) // adds extra space of 0.28 between each character
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(Color.white)
                    .cornerRadius(17)
                    .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 4)
                    .padding(.bottom, 0)

                SecureField("Password", text: $password)
                    .font(Font.custom("Baloo Bhaijaan 2", size: 14))
                    .kerning(0.28) // adds extra space of 0.28 between each character
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(Color.white)
                    .cornerRadius(17)
                    .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 4)


            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 50)

            // Sign In Button
            Button(action: {
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    if let error = error {
                        print("Login failed:", error.localizedDescription)
                    } else {
                        print("Login success! UID:", result?.user.uid ?? "")
                    }
                }
            }) {
                Text("Sign In")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .font(Font.custom("Baloo Bhaijaan 2", size: 14))
                    .kerning(0.28) // adds extra space of 0.28 between each character
                    .background(Color(red: 0.43, green: 0.57, blue: 0.65))
                    .foregroundColor(.white)
                    .cornerRadius(17)
                    .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 4)

            }
            .frame(maxWidth: .infinity) //The button fills the width minus 36pt padding on both sides.
            .padding(.horizontal, 50)

            // OR Divider
            HStack {

                Rectangle().frame(width: 70, height: 1).foregroundColor(.black)
                Text("or").foregroundColor(.black)
                    .font(Font.custom("Baloo Bhaijaan 2", size: 12))
                Rectangle().frame(width: 70, height: 1).foregroundColor(.black)
            }
            .padding(.horizontal, 32)



            HStack(spacing:24) {
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



            // Sign Up / Forgot Password Links
            VStack(spacing: 1) {
                HStack(spacing: 0){

                    Text("Don’t have an account?")
                      .font(Font.custom("ABeeZee", size: 10))
                      .multilineTextAlignment(.center)
                      .foregroundColor(.black)
                      .frame(width: 120, height: 19, alignment: .top)

                    Button(action:{}) { // Handle signup for account with email and password
                    }
                        Text("Sign Up")
                            .font(Font.custom("ABeeZee", size: 10))
                            .underline(true, pattern: .solid)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.49, green: 0.63, blue: 0.66))

                            .frame(width: 40, height: 19, alignment: .top)
                            .offset(x: -3)

                }


                Button(action: {}) {
                    // Handle forgot password
                }
                    Text("Forgot Password?")
                        .font(Font.custom("ABeeZee", size: 10))
                        .underline(true, pattern: .solid)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.49, green: 0.63, blue: 0.66))
                        .frame(width: 182, height: 19, alignment: .top)
            }
            .padding(.top, 8)

            Spacer()
        }
        .padding(.top)
        .background(
            RoundedCorner(radius: 900, corners: [.topLeft, .topRight])
                .fill(Color(red: 0.89, green: 0.96, blue: 0.97))
                .edgesIgnoringSafeArea(.bottom)
                .offset(x: 0, y: 200)
        )
    }
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
