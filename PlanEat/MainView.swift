import SwiftUI
import FirebaseAuth

enum Tab {
    case home, calendar, favorites, profile
}

struct MainView: View {
    @State private var selectedTab: Tab = .home

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
                            try? Auth.auth().signOut()
                            exit(0)
                        }
                        .padding().background(.red).foregroundColor(.white).cornerRadius(8)
                    }
                }
            }
            BottomNavigationBar(selectedTab: $selectedTab)
        }
    }
}
