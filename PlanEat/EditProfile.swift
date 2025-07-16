import SwiftUI

struct ProfileView: View {
    @State private var name: String = "--"
    @State private var dateOfBirth: Date = Calendar.current.date(from: DateComponents(year: 2000, month: 4, day: 25)) ?? Date()
    @State private var goal: String = "---"
    @State private var specialCondition: String = "---"
    
    let goals = ["Diet", "Muscle Gain", "Maintenance", "Detox"]
    let conditions = ["Diabetes", "Hypertension", "None"]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 30) {
                // Navigation Bar
                HStack(spacing: 8) {
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.black)
                    }
                    Text("Profile")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.top, 30)
                .padding(.horizontal, 60)
                .padding(.bottom, 0)
                
                Spacer() // Top Spacer for vertical centering

                // Centered profile form and Save button
                VStack(spacing:40) {
                    VStack(alignment: .leading, spacing: 22) {
                        // Name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(.system(size: 16))
                            HStack {
                                TextField("", text: $name)
                                    .disabled(true)
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: 16))
                                Spacer()
                                Image(systemName: "pencil")
                                    .foregroundColor(Color.gray.opacity(0.7))
                            }
                            .padding(.horizontal, 18)
                            .frame(height: 48)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.06), radius: 8, x: 0, y: 2)
                            )
                        }
                        // Date of Birth
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Date of Birth")
                                .font(.system(size: 16))
                            HStack {
                                Text(dateToString(dateOfBirth))
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: 16))
                                Spacer()
                                Image(systemName: "calendar")
                                    .foregroundColor(Color.gray.opacity(0.7))
                            }
                            .padding(.horizontal, 18)
                            .frame(height: 48)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.06), radius: 8, x: 0, y: 2)
                            )
                        }
                        // Goal
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Goal")
                                .font(.system(size: 16))
                            HStack {
                                Text(goal)
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: 16))
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(Color.gray.opacity(0.7))
                            }
                            .padding(.horizontal, 18)
                            .frame(height: 48)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.06), radius: 8, x: 0, y: 2)
                            )
                        }
                        // Special Condition
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Special Condition")
                                .font(.system(size: 16))
                            HStack {
                                Text(specialCondition)
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: 16))
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(Color.gray.opacity(0.7))
                            }
                            .padding(.horizontal, 18)
                            .frame(height: 48)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.06), radius: 8, x: 0, y: 2)
                            )
                        }
                    }
                    .frame(maxWidth: 300) // <--- Limit max width of form
                    .padding(.horizontal)
                    
                    // Save Button
                    HStack {
                        Spacer()
                        Button(action: {}) {
                            Text("Save")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: 140, height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(Color(red: 113/255, green: 139/255, blue: 155/255))
                                )
                                .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.08), radius: 6, x: 0, y: 4)
                        }
                        Spacer()
                    }
                }
                
                Spacer() // Bottom Spacer for vertical centering
                .padding(.top, 30)

            }
            
            // Custom Tab Bar (unchanged)
            ZStack {
                CustomToolBar()
                    .fill(Color(red: 0.43, green: 0.57, blue: 0.65))
                    .frame(width: 480, height: 90)
                    .edgesIgnoringSafeArea(.bottom)
                    
                HStack {
                    Spacer()
                    Image(systemName: "house")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .offset(x: 10, y: 6)
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.25, green: 0.37, blue: 0.44))
                            .frame(width: 95, height: 95)
                            .shadow(color: .black.opacity(0.6), radius: 3, x: 0, y: 4)
                            .offset(x: 165, y: 15)
                        Image(systemName: "calendar")
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                            .offset(x: -26, y: 47)
                    }
                    .offset(y: -40)
                    Spacer()
                    Image(systemName: "star")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .offset(x: -65, y: 6)
                    Spacer()
                    Image(systemName: "person")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .offset(x: -43, y: -25)
                    Spacer()

                }
               
            }
            .padding(.bottom, -17)
        }
        .background(Color.white.ignoresSafeArea())
    }
    
    func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
}


// Simple Custom TabBar with floating circle effect for "person" icon
struct CustomToolBar: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height + 40
        let cornerRadius: CGFloat = 16
        let notchRadius: CGFloat = 65
        let centerX = width / 2 + 125
        let notchDepth: CGFloat = 20
        
        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        path.addQuadCurve(to: CGPoint(x: cornerRadius, y: 0), control: CGPoint(x: 0, y: 0))
        
        path.addLine(to: CGPoint(x: centerX - notchRadius - 40, y: 0))
        path.addQuadCurve(
            to: CGPoint(x: centerX - notchRadius, y: notchDepth * 1.5),
            control: CGPoint(x: centerX - notchRadius + 0.5, y: 0)
        )
        
        path.addArc(
            center: CGPoint(x: centerX, y: notchDepth),
            radius: notchRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: true
        )
        
        path.addQuadCurve(
            to: CGPoint(x: centerX + notchRadius + 30, y: 0),
            control: CGPoint(x: centerX + notchRadius + 1, y: 0)
        )
        path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
        path.addQuadCurve(to: CGPoint(x: width, y: cornerRadius), control: CGPoint(x: width, y: 0))
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.closeSubpath()
        
        return path
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

