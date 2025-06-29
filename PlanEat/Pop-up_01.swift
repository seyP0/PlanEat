import SwiftUI

struct MoodPopupView: View {
    @State private var selectedMoodFace: String? = nil
    @State private var selectedMoodLabel: String? = nil

    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("How’s your mood today?")
                    .font(
                        Font.custom("BalooBhaijaan2-Bold", size: 20)
                            .weight(.bold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .offset(y: 10)

                Text("Click the face based on your mood")
                    .font(Font.custom("Baloo Bhaijaan 2", size: 10))
                    .foregroundColor(.black)
                    .offset(y: -5)

                // Mood Faces (interactive + disabled state on selection)
                HStack(spacing: 16) {
                    MoodFaceButton(name: "Happy", imageName: "smile", selectedImageName: "smile 10", isSelected: selectedMoodFace == "Happy") {
                        selectedMoodFace = "Happy"
                    }
                    MoodFaceButton(name: "Neutral", imageName: "smile-3", selectedImageName: "smile-21", isSelected: selectedMoodFace == "Neutral") {
                        selectedMoodFace = "Neutral"
                    }
                    MoodFaceButton(name: "Sad", imageName: "smile-1", selectedImageName: "smile-11", isSelected: selectedMoodFace == "Sad") {
                        selectedMoodFace = "Sad"
                    }
                    MoodFaceButton(name: "Angry", imageName: "smile 4", selectedImageName: "smile-2", isSelected: selectedMoodFace == "Angry") {
                        selectedMoodFace = "Angry"
                    }
                }
                .frame(height: 60)
    

                // Mood Buttons (with selection and hover state)
                VStack(spacing: 15) {
                    HStack(spacing: 16) {
                        MoodButton(label: "Drained", isSelected: selectedMoodLabel == "Drained") {
                            selectedMoodLabel = "Drained"
                        }
                        MoodButton(label: "Heavy", isSelected: selectedMoodLabel == "Heavy") {
                            selectedMoodLabel = "Heavy"
                        }
                    }
                    HStack(spacing: 16) {
                        MoodButton(label: "Irritated", isSelected: selectedMoodLabel == "Irritated") {
                            selectedMoodLabel = "Irritated"
                        }
                        MoodButton(label: "Down", isSelected: selectedMoodLabel == "Down") {
                            selectedMoodLabel = "Down"
                        }
                    }
                    HStack(spacing: 16) {
                        MoodButton(label: "Bloated", isSelected: selectedMoodLabel == "Bloated") {
                            selectedMoodLabel = "Bloated"
                        }
                        MoodButton(label: "Foggy", isSelected: selectedMoodLabel == "Foggy") {
                            selectedMoodLabel = "Foggy"
                        }
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

// MARK: - Mood Face Button (Image Toggle)
struct MoodFaceButton: View {
    let name: String
    let imageName: String
    let selectedImageName: String
    let isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(isSelected ? selectedImageName : imageName)
                .resizable()
                .frame(width: 65, height: 65)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Mood Label Button (Selectable + Hover)
struct MoodButton: View {
    let label: String
    var isSelected: Bool
    var action: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(Font.custom("Baloo Bhaijaan 2", size: 10))
                .foregroundColor(isSelected || isHovered ? .white : baseColor)
                .frame(width: 125, height: 25)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(isSelected || isHovered ? baseColor : .clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(baseColor, lineWidth: isSelected ? 0 : 1)
                )
                .opacity(isHovered && !isSelected ? 0.5 : 1.0)
        }
        .onHover { hovering in
            isHovered = hovering
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isHovered)
    }

    private var baseColor: Color {
        Color(#colorLiteral(red: 0.25, green: 0.31, blue: 0.45, alpha: 1)) // navy
    }
}

struct MoodPopupView_Previews: PreviewProvider {
    static var previews: some View {
        MoodPopupView()
            .previewLayout(.sizeThatFits)
    }
}
