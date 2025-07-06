import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    
                    // MARK: – Day Header
                    Text("Monday")
                        .font(Font.custom("Baloo Bhaijaan 2", size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.32, green: 0.39, blue: 0.47))
                        .padding(.top, 20)
                    
                    // MARK: – Meal Rows
                    VStack(spacing: 16) {
                        MealRow(mealType: "Breakfast", description: "--")
                        MealRow(mealType: "Lunch", description: "--")
                        MealRow(mealType: "Dinner", description: "--")
                    }
                    .padding(.horizontal)
                    
                }
                .frame(maxWidth: .infinity)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // TODO: your back action
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .medium))
                            Text("Home")
                                .font(.headline)
                        }
                        .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct MealRow: View {
    let mealType: String
    let description: String

    var body: some View {
        HStack(spacing: 12) {
            // blank placeholder matching the image size
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 70, height: 70)
            
            // “Breakfast : Avocado egg toast & milk”
            Text("\(mealType) :")
                .font(Font.custom("Baloo Bhaijaan 2", size: 15))
                .fontWeight(.semibold)
                .foregroundColor(Color(red: 0.32, green: 0.39, blue: 0.47))
            Text(description)
                .font(Font.custom("Baloo Bhaijaan 2", size: 15))
                .foregroundColor(Color(red: 0.32, green: 0.39, blue: 0.47))
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(red: 104/255, green: 117/255, blue: 140/255), lineWidth: 1)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
