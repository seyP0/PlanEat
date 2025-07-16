import SwiftUI

struct FirstPopUp: View {
    @Binding var selectedMoodFace: String?
    @Binding var selectedMoodLabel: String?
    var onDismiss: () -> Void


    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture(perform: onDismiss)


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
                    MoodFaceButton(name: "Happy", imageName: "smile", selectedImageName: "smileFaded", isSelected: selectedMoodFace == "Happy") {
                        selectedMoodFace = "Happy"
                    }
                    MoodFaceButton(name: "Neutral", imageName: "neutral", selectedImageName: "neutralFaded", isSelected: selectedMoodFace == "Neutral") {
                        selectedMoodFace = "Neutral"
                    }
                    MoodFaceButton(name: "Sad", imageName: "sad", selectedImageName: "sadFaded", isSelected: selectedMoodFace == "Sad") {
                        selectedMoodFace = "Sad"
                    }
                    MoodFaceButton(name: "Angry", imageName: "angry", selectedImageName: "angryFaded", isSelected: selectedMoodFace == "Angry") {
                        selectedMoodFace = "Angry"
                    }
                }
                .frame(height: 60)
    

                // Mood Buttons (with selection and hover state)
                VStack(spacing: 15) {
                    HStack(spacing: 16) {
                        MoodLabelButton(label: "Drained", isSelected: selectedMoodLabel == "Drained") {
                            selectedMoodLabel = "Drained"
                        }
                        MoodLabelButton(label: "Heavy", isSelected: selectedMoodLabel == "Heavy") {
                            selectedMoodLabel = "Heavy"
                        }
                    }
                    HStack(spacing: 16) {
                        MoodLabelButton(label: "Irritated", isSelected: selectedMoodLabel == "Irritated") {
                            selectedMoodLabel = "Irritated"
                        }
                        MoodLabelButton(label: "Down", isSelected: selectedMoodLabel == "Down") {
                            selectedMoodLabel = "Down"
                        }
                    }
                    HStack(spacing: 16) {
                        MoodLabelButton(label: "Bloated", isSelected: selectedMoodLabel == "Bloated") {
                            selectedMoodLabel = "Bloated"
                        }
                        MoodLabelButton(label: "Foggy", isSelected: selectedMoodLabel == "Foggy") {
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
struct MoodLabelButton: View {
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

//struct FirstPopUp_Previews: PreviewProvider {
//    static var previews: some View {
//        FirstPopUp(onDismiss: {})
//            .previewLayout(.sizeThatFits)
//    }
//
//    
//}
