import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var email: String = ""

    // Custom colors matching the design
    private let backgroundColor = Color(red: 237/255, green: 249/255, blue: 249/255)
    private let accentColor = Color(red: 116/255, green: 146/255, blue: 161/255)

    var body: some View {
        ZStack {
            // Background
            backgroundColor
                .edgesIgnoringSafeArea(.all)

            VStack {
                // Top navigation
                HStack(spacing: 13) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.black)
                    }
                    Text("Forgot password")
                        .font(.subheadline)
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.top ,20)
                .padding()
                Spacer()

                // Lock icon in circle
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 200, height: 200)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)

                    Image(systemName: "lock.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(accentColor)
                }
                .padding(.top ,-70)
                Spacer().frame(height: 40)
                    .padding(.bottom ,-10)

                // Instruction text
                Text("Please enter your email address\nto receive a verification cord.")
                    .font(Font.custom("Baloo Bhaijaan 2", size: 15))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.horizontal, 30)
                

                
                // Email input
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.horizontal, 40)
                    .padding(.top, 20)

                // Send button
                Button(action: {
                    // TODO: handle send action
                }) {
                    Text("Send")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 140, height: 45)
                        .background(accentColor)
                        .cornerRadius(16)
                }
                .padding(.top, 30)

                Spacer()
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
