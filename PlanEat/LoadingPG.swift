import SwiftUI

struct LoadingPG: View {
    @State private var isActive = false
    @State private var leftMouth = "mouthNeutral"
    @State private var rightMouth = "mouthNeutral"

    var body: some View {
        if isActive {
            LogIn()
        } else {
            ZStack {
                Color.white.ignoresSafeArea()

                HStack(spacing: 50) {
                    // LEFT FACE
                    ZStack {
                        Image("faceLeft")
                        Image(leftMouth)
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 0.5), value: leftMouth)
                    }

                    // RIGHT FACE
                    ZStack {
                        Image("faceRight")
                        Image(rightMouth)
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 0.5), value: rightMouth)
                    }
                }
                .frame(height: 200)
            }
            .onAppear {
                // Animate mouths after short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    leftMouth = "mouthSmile"
                    rightMouth = "mouthFrown"
                }

                // Navigate after full delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}
