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
                    SettingsView()
                }
            }
            BottomNavigationBar(selectedTab: $selectedTab)
        }
    }
}
