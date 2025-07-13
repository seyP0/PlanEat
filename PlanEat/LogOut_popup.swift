import SwiftUI

// MARK: – Custom ButtonStyle (unchanged)
struct ContrastButtonStyle: ButtonStyle {
    let accent = Color(red: 104/255, green: 117/255, blue: 140/255)

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.custom("Baloo Bhaijaan 2", size: 18))
            .frame(width: 120, height: 44)
            .background(configuration.isPressed ? accent : Color.white)
            .foregroundColor(configuration.isPressed ? .white : accent)
            .overlay(
                Capsule().stroke(accent, lineWidth: 1)
            )
            .cornerRadius(22)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: – ConfirmPopup with NavigationLink
struct ConfirmPopup: View {
    @State private var navigateToLogin = false
    var onNo: (() -> Void)? = nil

    var body: some View {
        ZStack {
            // Hidden link that activates when navigateToLogin = true
            NavigationLink(destination: LogIn(), isActive: $navigateToLogin) {
                EmptyView()
            }

            // The white card
            VStack(spacing: 30) {
                HStack(spacing: 8) {
                    Text("Are you sure?")
                        .font(Font.custom("Baloo Bhaijaan 2", size: 24))
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    Image("smile-11")
                        .resizable()
                        .frame(width: 30, height: 30)
                }

                HStack(spacing: 24) {
                    Button("Yes") {
                        navigateToLogin = true
                    }
                    .buttonStyle(ContrastButtonStyle())

                    Button("No") {
                        onNo?()
                    }
                    .buttonStyle(ContrastButtonStyle())
                }
            }
            .padding(.vertical, 32)
            .padding(.horizontal, 40)
            .frame(width: 350)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
    }
}
// MARK: – Preview
struct ConfirmPopup_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)
            ConfirmPopup(onNo: {
                print("No tapped")
            })
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
