import SwiftUI
import FirebaseAuth

struct LoadingPG: View {
    @State private var isActive = false
    @State private var leftMouth = "mouthNeutral"
    @State private var rightMouth = "mouthNeutral"
    @State private var isLoggedIn: Bool? = nil

    var body: some View {
        Group {
            if let loggedIn = isLoggedIn {
                if loggedIn {
                    MainView()
                } else {
                    LogIn()
                }
            } else {
                splashScreen
            }
        }
        .onAppear {
            animateMouths()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                isLoggedIn = Auth.auth().currentUser != nil
            }
        }
    }

    var splashScreen: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            ZStack {
                Image("logoname")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 280)

                ZStack {
                    Image("faceLeft")
                    Image(leftMouth)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 1.0), value: leftMouth)
                        .offset(x: 0, y: 4)
                }
                .frame(width: 40, height: 40)
                .offset(x: -67.5, y: 12)

                ZStack {
                    Image("faceRight")
                    Image(rightMouth)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 1.0), value: rightMouth)
                        .offset(x: 0, y: 4)
                }
                .frame(width: 40, height: 40)
                .offset(x: 43, y: 12)
            }
            .padding(.top, 60)
            .offset(x: 15, y: -50)
        }
    }

    func animateMouths() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            leftMouth = "mouthSmile"
            rightMouth = "mouthFrown"
        }
    }
}
