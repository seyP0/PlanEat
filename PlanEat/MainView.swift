import SwiftUI
import FirebaseAuth

enum Tab {
    case home, calendar, favorites, profile
}

struct MainView: View {
    @State private var selectedTab: Tab = .home
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch selectedTab {
                case .home:
                    HomePage()
                case .calendar:
                    Text("Calendar Page")
                case .favorites:
                    Text("Favorites Page")
                case .profile:
                    VStack {
                        Text("Profile Page")

                        Button("Sign Out") {
                            do {
                                try Auth.auth().signOut()
                                dismiss()
                            } catch {
                                print("Error signing out: \(error.localizedDescription)")
                            }
                        }
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
            }

            BottomNavigationBar(selectedTab: $selectedTab)
        }
    }
}
