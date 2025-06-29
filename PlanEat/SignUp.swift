import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var dob = Date()

    @State private var selectedGender = ""
    @State private var selectedGoal = ""
    @State private var selectedCondition = ""

    let genders = ["Male", "Female", "Other"]
    let goals = ["Weight Loss", "Muscle Gain", "Maintenance", "Detox"]
    let conditions = ["None", "Diabetes", "Hypertension", "Allergies"]

    var body: some View {
        VStack(spacing: 20) {
            Group {
                CustomTextField(label: "Name", text: $name)
                CustomTextField(label: "Email", text: $email)
                CustomTextField(label: "Password", text: $password, isSecure: true)

                VStack(alignment: .leading, spacing: 5) {
                    Text("Date of Birth")
                        .font(.custom("Baloo Bhaijaan 2", size: 14))
                    HStack {
                        DatePicker("", selection: $dob, displayedComponents: .date)
                            .labelsHidden()
                        Spacer()
                        Image(systemName: "calendar")
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 4)
                }
            }

            CustomPicker(label: "Gender", selection: $selectedGender, options: genders)
            CustomPicker(label: "Goal", selection: $selectedGoal, options: goals)
            CustomPicker(label: "Special Condition", selection: $selectedCondition, options: conditions)

                            Button(action: {
                    Auth.auth().createUser(withEmail: email, password: password) { result, error in
                        if let error = error {
                            print("Sign Up failed:", error.localizedDescription)
                        } else if let uid = result?.user.uid {
                            let db = Firestore.firestore()
                            db.collection("users").document(uid).setData([
                                "name": name,
                                "email": email,
                                "dob": Timestamp(date: dob),
                                "gender": selectedGender,
                                "goal": selectedGoal,
                                "condition": selectedCondition,
                                "createdAt": FieldValue.serverTimestamp()
                            ]) { error in
                                if let error = error {
                                    print("Failed to store user data:", error.localizedDescription)
                                } else {
                                    print("User data saved for UID:", uid)
                                }
                            }
                        }
                    }
                })
 {
                Text("Create")
                    .font(.custom("Baloo Bhaijaan 2", size: 16))
                    .padding()
                    .frame(width: 140)
                    .background(Color(red: 0.43, green: 0.57, blue: 0.65))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
            }
            .padding(.top, 30)
        }
        .padding()
        .background(Color(red: 0.89, green: 0.96, blue: 0.97).ignoresSafeArea())
    }
}
struct CustomTextField: View {
    var label: String
    @Binding var text: String
    var isSecure: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.custom("Baloo Bhaijaan 2", size: 14))
            Group {
                if isSecure {
                    SecureField("", text: $text)
                } else {
                    TextField("", text: $text)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 4)
        }
    }
}

struct CustomPicker: View {
    var label: String
    @Binding var selection: String
    var options: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.custom("Baloo Bhaijaan 2", size: 14))
            Picker("", selection: $selection) {
                ForEach(options, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 4)
        }
    }
}
