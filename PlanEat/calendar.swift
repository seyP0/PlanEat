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
                        Image("stone")
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

            
        }
        .padding(.top, 30)
        .background(Color.white)
    }
}


struct CalendarSmileView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarSmileView()
    }
}


