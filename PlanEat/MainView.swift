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
                    CalendarSmileView()
                case .favorites:
                    MealView()
                case .profile:
<<<<<<< HEAD
                    SettingsView()
=======
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
>>>>>>> ee95ae01b2b0f56a11ade7d6c6c29710431de325
                }
            }
            BottomNavigationBar(selectedTab: $selectedTab)
        }
    }
}
