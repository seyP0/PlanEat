import SwiftUI

struct CalendarSmileView: View {
    let days = ["sun", "mon", "tues", "wed", "thurs", "fri", "sat"]
    let dates = Array(1...31)

    var body: some View {
        VStack(spacing: 60) {
            // Header
            HStack {
                Spacer()
                Text("May 2025")
                    .font(.title2)
                    .bold()
                Image(systemName: "chevron.down")
                    .foregroundColor(Color(red: 104/255, green: 117/255, blue: 140/255))
                    .offset(x: 5)
                Spacer()
            }
            .offset(x: 10, y: 10)

            VStack {
                // Weekday row
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                    ForEach(days, id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                    }
                }
                .offset(y: -50)

                // Calendar Grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 25) {
                    ForEach(0..<42, id: \.self) { index in
                        if index < 4 {
                            Color.clear.frame(height: 44)
                        } else if index - 4 < dates.count {
                            VStack(spacing: 5) {
                                Image("smile 2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                Text("\(dates[index - 4])")
                                    .font(.caption2)
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity)
                        } else {
                            Color.clear.frame(height: 44)
                        }
                    }
                }
                .offset(y: -15)
            }
            .offset(y: 65)

            // Tab Bar
            ZStack {
                CustomTabBarShape()
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
        .frame(width: 393, height: 852)
        .background(Color.white)
    }
}

struct CustomTabBarShape: Shape {
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

