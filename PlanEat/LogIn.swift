import SwiftUI

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
                // Handle sign in
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

            // Google & Apple Sign-In Buttons
            HStack(spacing: 24) {
                Image("Google")
                    .resizable()
                    .frame(width: 44, height: 44)

                Image("Apple")
                    .resizable()
                    .frame(width: 44, height: 44)
            }

            // Sign Up / Forgot Password Links
            VStack(spacing: 4) {
                HStack {
                    Text("Don't have an account?")
                    Button("Sign Up") {
                        // Handle sign up nav
                    }.fontWeight(.medium)
                }

                Button("Forgot password?") {
                    // Handle forgot password
                }
                .font(.footnote)
                .foregroundColor(.gray)
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



