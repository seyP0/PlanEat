
import SwiftUI

struct MoodPopupView: View {
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)

            // Centered Popup
            VStack(spacing: 16) {
                Text("How’s your mood today?")
                    .font(
                    Font.custom("Baloo_Bhaijaan_2", size: 20)
                    .weight(.bold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)

                Text("Click the face based on your mood")
                    .font(.system(size: 12))
                    .foregroundColor(.black)

                // Mood Faces
                HStack(spacing: 16) {
                    Image("smile")        // Happy
                    Image("smile-3")      // Neutral
                    Image("smile-1")      // Sad
                    Image("smile-2")      // Angry
                }
                .frame(height: 60)

                // Mood Buttons
                VStack(spacing: 12) {
                    HStack(spacing: 16) {
                        MoodButton(label: "Drained")
                        MoodButton(label: "Heavy")
                    }
                    HStack(spacing: 16) {
                        MoodButton(label: "Irritated")
                        MoodButton(label: "Down")
                    }
                    HStack(spacing: 16) {
                        MoodButton(label: "Bloated")
                        MoodButton(label: "Foggy")
                    }
                }

                Spacer()
            }
            .padding(.top, 24)
            .padding(.bottom, 16)
            .frame(width: 362, height: 311)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }
}

struct MoodButton: View {
    let label: String

    var body: some View {
        Text(label)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(Color(#colorLiteral(red: 0.25, green: 0.31, blue: 0.45, alpha: 1)))
            .frame(width: 120, height: 35)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color(#colorLiteral(red: 0.25, green: 0.31, blue: 0.45, alpha: 1)), lineWidth: 1)
            )
    }
}

struct MoodPopupView_Previews: PreviewProvider {
    static var previews: some View {
        MoodPopupView()
            .previewDevice("iPhone 16 Pro Max")
    }
}
