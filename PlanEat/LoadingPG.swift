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

//                VStack(spacing: 30) {
//                    // LOGO TEXT (no faces)
//                    Image("logoname")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 280)
//                        .padding(.top, 40)
//
//                    // ANIMATED FACES
//                    HStack(spacing: 60) {
//                        ZStack {
//                            Image("faceLeft")
//                            Image(leftMouth)
//                                .transition(.opacity)
//                                .animation(.easeInOut(duration: 1.0), value: leftMouth)
//                        }
//
//                        ZStack {
//                            Image("faceRight")
//                            Image(rightMouth)
//                                .transition(.opacity)
//                                .animation(.easeInOut(duration: 1.0), value: rightMouth)
//                        }
//                    }
//                    .frame(height: 200)
//                }
                
                ZStack {
                    
                    // Full logo image with the "a" letters
                    Image("logoname") // this should include all letters including the a's
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280)

                    // LEFT FACE (inside first "a")
                    ZStack {
                        Image("faceLeft")
                        Image(leftMouth)
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 1.0), value: leftMouth)
                            .offset(x: 0, y: 4)
                    }
                    .frame(width: 40, height: 40)
                    .offset(x: -67.5, y: 12) // tweak this until it's centered inside the first "a"

                    // RIGHT FACE (inside second "a")
                    ZStack {
                        Image("faceRight")
                        Image(rightMouth)
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 1.0), value: rightMouth)
                            .offset(x: 0, y: 4)
                    }
                    .frame(width: 40, height: 40)
                    .offset(x: 43, y: 12) // tweak this until it's centered inside the second "a"
                }
                .padding(.top, 60)
            }
            .onAppear {
                // Animate mouths
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    leftMouth = "mouthSmile"
                    rightMouth = "mouthFrown"
                }

                // Navigate to next screen
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}
