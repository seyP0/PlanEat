import SwiftUI

struct NutritionFactsPopup: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .frame(width: 362, height: 497)
                    .overlay(
                        VStack(spacing: 20) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 12))
                                    .foregroundColor(.black)
                                Text("Home")
                                    .font(.system(size: 12))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 12)

                            Text("Nutrition Facts")
                                .font(.system(size: 18, weight: .bold))

                            VStack(spacing: 20) {
                                Text("Avocado Egg Toast")
                                    .underline()
                                    .font(.system(size: 14, weight: .bold))

                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text("Food:").bold().frame(width: 120, alignment: .leading).font(.system(size: 11))
                                        Text("Protein").bold().frame(width: 50, alignment: .leading).font(.system(size: 11))
                                        Text("Fat").bold().frame(width: 40, alignment: .leading).font(.system(size: 11))
                                        Text("Carbs").bold().frame(width: 50, alignment: .leading).font(.system(size: 11))
                                    }

                                    HStack {
                                        Text("\u{2022} 1/2 Avocado").frame(width: 120, alignment: .leading).font(.system(size: 11))
                                        Text("15g").frame(width: 50, alignment: .leading).font(.system(size: 11))
                                        Text("1.5g").frame(width: 40, alignment: .leading).font(.system(size: 11))
                                        Text("9g").frame(width: 50, alignment: .leading).font(.system(size: 11))
                                    }
                                    HStack {
                                        Text("\u{2022} 1 Egg").frame(width: 120, alignment: .leading).font(.system(size: 11))
                                        Text("6g").frame(width: 50, alignment: .leading).font(.system(size: 11))
                                        Text("5g").frame(width: 40, alignment: .leading).font(.system(size: 11))
                                        Text("0.5g").frame(width: 50, alignment: .leading).font(.system(size: 11))
                                    }
                                    HStack {
                                        Text("\u{2022} 1 slice of toast").frame(width: 120, alignment: .leading).font(.system(size: 11))
                                        Text("4g").frame(width: 50, alignment: .leading).font(.system(size: 11))
                                        Text("1.5g").frame(width: 40, alignment: .leading).font(.system(size: 11))
                                        Text("15g").frame(width: 50, alignment: .leading).font(.system(size: 11))
                                    }
                                }

                                Text("Total Calories: 350")
                                    .font(.system(size: 11, weight: .bold))
                            }
                            .frame(width: 290)
                            .padding(10)
                            .background(Color(red: 94/255, green: 117/255, blue: 140/255))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.65), radius: 2, x:0, y:3)

                            VStack(spacing: 10) {
                                Text("1 cup of Milk")
                                    .underline()
                                    .font(.system(size: 14, weight: .bold))
                                    .padding(.bottom, 1)

                                HStack {
                                    Text("Protein").bold().frame(width: 60, alignment: .leading).font(.system(size: 11))
                                    Text("Fat").bold().frame(width: 40, alignment: .leading).font(.system(size: 11))
                                    Text("Carbs").bold().frame(width: 50, alignment: .leading).font(.system(size: 11))
                                }
                                HStack {
                                    Text("8g").frame(width: 60, alignment: .leading).font(.system(size: 11))
                                    Text("5g").frame(width: 40, alignment: .leading).font(.system(size: 11))
                                    Text("12g").frame(width: 50, alignment: .leading).font(.system(size: 11))
                                }

                                Text("Total Calories: 125")
                                    .font(.system(size: 11, weight: .bold))
                            }
                            .frame(width: 290)
                            .padding(10)
                            .background(Color(red: 94/255, green: 117/255, blue: 140/255))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.65), radius: 2, x:0, y:3)

                            Text("Don’t want this meal?")
                                .foregroundColor(.gray)
                                .font(.system(size: 12))

                            Image(systemName: "xmark.circle")
                                .font(.system(size: 24))
                                .foregroundColor(.red)
                                .padding(.top, -10)
                                .padding(.bottom, 6)
                            
                        }
                        .frame(width: 330)
                    )

                Spacer()
            }
        }
    }
}

struct NutritionFactsPopup_Previews: PreviewProvider {
    static var previews: some View {
        NutritionFactsPopup()
    }
}

