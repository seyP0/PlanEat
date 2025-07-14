import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var email = ""
    @State private var emailSent = false
    @State private var errorMessage = ""

    var body: some View {
        ZStack {
            Color(red: 237/255, green: 249/255, blue: 249/255)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                Spacer()

                Image(systemName: "paperplane.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(Color(red: 116/255, green: 146/255, blue: 161/255))

                if emailSent {
                    Text("Password reset email sent! Please check your inbox.")
                        .multilineTextAlignment(.center)
                        .padding()

                    Button("Back to Login") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)

                } else {
                    Text("Enter your email to reset your password")
                        .font(.headline)

                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 40)
                        .autocapitalization(.none)

                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    Button("Send Reset Email") {
                        sendResetEmail()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }

                Spacer()
            }
            .padding()
        }
    }

    private func sendResetEmail() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                emailSent = true
            }
        }
    }
}
