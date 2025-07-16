struct BottomNavigationBar: View {
    @Binding var selectedTab: Tab

    var body: some View {
        ZStack {
            CustomTabBarShape()
                .fill(Color(red: 0.43, green: 0.57, blue: 0.65))
                .frame(height: 90)
                .edgesIgnoringSafeArea(.bottom)

            HStack(spacing: 0) {
                TabButton(icon: "house.fill", tab: .home)
                TabButton(icon: "calendar", tab: .calendar)
                TabButton(icon: "star", tab: .favorites)
                TabButton(icon: "person", tab: .profile)
            }
            .padding(.horizontal, 20)

            Circle()
                .fill(Color(red: 0.25, green: 0.37, blue: 0.44))
                .frame(width: 95, height: 95)
                .shadow(color: .black.opacity(0.6), radius: 3, x: 0, y: 4)
                .overlay(
                    Image(systemName: selectedTabIcon)
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                )
                .offset(x: -UIScreen.main.bounds.width / 2 + 67, y: -25)
        }
        .frame(height: 90)
    }

    var selectedTabIcon: String {
        switch selectedTab {
        case .home: return "house.fill"
        case .calendar: return "calendar"
        case .favorites: return "star"
        case .profile: return "person"
        }
    }

    func TabButton(icon: String, tab: Tab) -> some View {
        VStack {
            Spacer()
            Button {
                selectedTab = tab
            } label: {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 25))
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
