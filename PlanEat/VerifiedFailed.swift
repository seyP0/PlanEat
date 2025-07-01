import SwiftUI

struct VerifiedFailed: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var code: [String] = ["", "", "", ""]
    @State private var isVerified: Bool = true


    // Colors
    private let backgroundColor = Color(red: 237/255, green: 249/255, blue: 249/255)
    private let accentColor = Color(red: 116/255, green: 146/255, blue: 161/255)

    var body: some View {
        ZStack {
            backgroundColor
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                // Top navigation
                HStack(spacing: 12) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.black)
                    }
                    Text("Verify Your Email")
                        .font(.subheadline)
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.top ,20)
                .padding()
                Spacer()

                // Paper plane icon in circle
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 200, height: 200)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)

                    // Replace "paperplane" with your asset name
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(accentColor)
                }
                .padding(.top , 10)
                Spacer().frame(height: 40)
                    .padding(.bottom ,-10)

                // Instruction text
                Text("Please enter the 4‑digit code sent via email")
                    .font(Font.custom("Baloo Bhaijaan 2", size: 15))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.vertical, -40)
                    .frame(width: 300, height: 21, alignment: .top)
                    

                // Code fields
                HStack(spacing: 15) {
                    ForEach(0..<4) { index in
                        TextField("", text: $code[index])
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .font(.title2)
                            .frame(width: 50, height: 50)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    }
                }
                .padding(.vertical, -40)

                // Resend link
                Button(action: {
                    // TODO: resend code
                }) {
                    Text("Resend Code")
                        .font(.caption)
                        .foregroundColor(accentColor)
                        .underline(true, pattern: .solid)
                        .padding(.vertical, 10)

                }

                // Verify button
                Button(action: {
                    // TODO: verify code
                }) {
                    Text("Verify")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 140, height: 45)
                        .background(accentColor)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
                // Show success message
                if isVerified {
                    Text("Unsuccessfully verified")
                        .font(
                        Font.custom("Baloo Bhaijaan 2", size: 20)
                        .weight(.heavy)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.99, green: 0.03, blue: 0.03))
                    
                        .padding(.bottom, -100)
                }
                Spacer()
                Spacer()
            }
        }
    }
}

struct VerifiedFailed_Previews: PreviewProvider {
    static var previews: some View {
        VerifiedFailed()
    }
}
