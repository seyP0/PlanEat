import SwiftUI

// MARK: – Custom ButtonStyle
struct ContrastButtonStyle: ButtonStyle {
    // Base colors
    let accent = Color(red: 104/255, green: 117/255, blue: 140/255)

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.custom("Baloo Bhaijaan 2", size: 18))
            .frame(width: 120, height: 44)
            .background(
                Group {
                    if configuration.isPressed {
                        // Pressed state: solid accent
                        accent
                    } else {
                        // Normal state: white
                        Color.white
                    }
                }
            )
            .foregroundColor(configuration.isPressed
                             ? Color.white
                             : accent)
            .overlay(
                Capsule()
                    .stroke(accent, lineWidth: 1)
            )
            .cornerRadius(22)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            #if os(iOS)
            // pointer-hover effect on iPadOS with a trackpad/mouse
            .hoverEffect(.highlight)
            #endif
    }
}

// MARK: – Pop-up Card
struct ConfirmPopup: View {
    var onYes: (() -> Void)? = nil
    var onNo: (() -> Void)? = nil

    var body: some View {
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
                Button("Yes") { onYes?() }
                    .buttonStyle(ContrastButtonStyle())
                Button("No") { onNo?() }
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

// MARK: – Preview
struct ConfirmPopup_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)
            ConfirmPopup {
                print("Yes")
            } onNo: {
                print("No")
            }
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
