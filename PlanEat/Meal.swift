import SwiftUI

struct MealView: View {
    var body: some View {
        VStack(spacing: 0) {
            
            // Top Navigation Bar
            HStack(spacing: 8) {
                Button(action: {
                    // your back action
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                        Text("Home")
                            .font(.headline)
                    }
                    .foregroundColor(.black)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 16)
            
            Spacer().frame(height: 20)
            
            // One Blue Rectangle Meal Example
            HStack {
                Text("--")
                    .bold()
                Spacer()
                Text("--")
                Spacer()
                Text("--kcal")
                Spacer()
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
            .padding()
            .frame(height: 50)
            .background(Color(red: 117/255, green: 144/255, blue: 160/255))
            .cornerRadius(20)
            .foregroundColor(.white)
            .padding(.horizontal)
            
            Spacer().frame(height: 20)
            
            // MORE + Box with same size
            Button(action: {}) {
                Text("MORE +")
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 117/255, green: 144/255, blue: 160/255))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(red: 117/255, green: 144/255, blue: 160/255), lineWidth: 1)
                    )
            }
            .padding(.horizontal)
            
            Spacer()
            
        }
        .padding(.top, 30)
        .background(Color.white)
    }
}


struct MealView_Previews: PreviewProvider {
    static var previews: some View {
        MealView()
    }
}
