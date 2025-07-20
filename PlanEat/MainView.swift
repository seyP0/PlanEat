import SwiftUI
import FirebaseAuth

enum Tab {
    case home, calendar, favorites, profile
}

struct MainView: View {
    @EnvironmentObject var session: SessionManager
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
                            session.signOut()
                        }
                        .padding()
                        .background(.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
            }
            BottomNavigationBar(selectedTab: $selectedTab)
        }
    }
}
