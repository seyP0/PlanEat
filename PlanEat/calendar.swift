import SwiftUI

struct CalendarSmileView: View {
    @State private var currentDate = Date()
    private let calendar = Calendar.current

    // Shortened weekday symbols e.g., Sun, Mon, Tue
    private var weekdays: [String] {
        let symbols = calendar.shortWeekdaySymbols
        let first = calendar.firstWeekday - 1
        let reordered = Array(symbols[first...] + symbols[..<first])
        return reordered.map { String($0.prefix(3)).capitalized }
    }

    // Header text "May 2025"
    private var monthYearText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: currentDate)
    }

    // All dates of current month
    private var monthDates: [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: currentDate),
              let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))
        else { return [] }
        return range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: monthStart)
        }
    }

    // Number of leading blanks before first weekday
    private var leadingBlankCount: Int {
        guard let first = monthDates.first else { return 0 }
        let weekday = calendar.component(.weekday, from: first) - calendar.firstWeekday
        return weekday < 0 ? weekday + 7 : weekday
    }

    var body: some View {
        VStack(spacing: 45) {
            // Header
            HStack {
                Spacer()
                Text(monthYearText)
                    .font(.title2)
                    .bold()
                Image(systemName: "chevron.down")
                    .foregroundColor(Color(red: 104/255, green: 117/255, blue: 140/255))
                    .offset(x: 5)
                Spacer()
            }
            .padding(.vertical, 10)

            // Weekday labels
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7), spacing: 5) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                }
            }

            // Dates grid
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 4), count: 7), spacing: 25) {
                // Leading blanks
                ForEach(0..<leadingBlankCount, id: \.self) { _ in
                    Color.clear.frame(height: 50)
                }
                // Days
                ForEach(monthDates, id: \.self) { date in
                    let day = calendar.component(.day, from: date)
                    VStack(spacing: 4) {
                        Image("smile 2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                        Text("\(day)")
                            .font(.caption2)
                            .foregroundColor(calendar.isDate(date, inSameDayAs: currentDate) ? .blue : .black)
                    }
                }
            }
            .offset(y: -15)

            Spacer()

            // Tab bar omitted for brevity
            // Tab Bar
            ZStack {
                CustomTabBar()
                    .fill(Color(red: 0.43, green: 0.57, blue: 0.65))
                    .frame(width: 450, height: 90)
                    .edgesIgnoringSafeArea(.bottom)
                
                HStack {
                    Spacer()
                    Image(systemName: "house")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .offset(x: 1, y: 3)
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.25, green: 0.37, blue: 0.44))
                            .frame(width: 95, height: 95)
                            .shadow(color: .black.opacity(0.6), radius: 3, x: 0, y: 4)
                            .offset(x: -1, y: 15)
                        Image(systemName: "calendar")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                            .offset(x: -1, y: 12)
                    }
                    .offset(y: -40)
                    Spacer()
                    Image(systemName: "star")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .offset(x: 2, y: 3)
                    Spacer()
                    Image(systemName: "person")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .offset(x: -1, y: 3)
                    Spacer()
                }
            }
        }
        .padding(.top, 30)
        .background(Color.white)
    }
}

struct CustomTabBar: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height + 40
        let cornerRadius: CGFloat = 16
        let notchRadius: CGFloat = 65
        let centerX = width / 2 - 40
        let notchDepth: CGFloat = 20// how far the notch cuts down

        // Start from bottom-left
        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        path.addQuadCurve(to: CGPoint(x: cornerRadius, y: 0), control: CGPoint(x: 0, y: 0))

        // Left edge before notch
        path.addLine(to: CGPoint(x: centerX - notchRadius - 40, y: 0))
        path.addQuadCurve(
            to: CGPoint(x: centerX - notchRadius, y: notchDepth * 1.5),
            control: CGPoint(x: centerX - notchRadius + 0.5, y: 0)
        )

        // Arc cutting downward for notch
        path.addArc(
            center: CGPoint(x: centerX, y: notchDepth),
            radius: notchRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: true
        )

        // Right edge after notch
//        path.addQuadCurve(
//            to: CGPoint(x: centerX + notchRadius + 20, y: notchDepth / 20),
//            control: CGPoint(x: centerX + notchRadius , y: notchDepth / 60 )
//        )
        path.addQuadCurve(
            to: CGPoint(x: centerX + notchRadius + 30, y: 0),
            control: CGPoint(x: centerX + notchRadius + 1, y: 0)
        )


        path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
        path.addQuadCurve(to: CGPoint(x: width, y: cornerRadius), control: CGPoint(x: width, y: 0))

        // Close bottom
        path.addLine(to: CGPoint(x: width, y: height))
        path.closeSubpath()

        return path
    }
}
struct CalendarSmileView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarSmileView()
    }
}


