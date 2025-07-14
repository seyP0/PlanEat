import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore

struct SignUp: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var dob = Date()
    @State private var selectedGender = ""
    @State private var selectedGoal = ""
    @State private var selectedCondition = ""
    @State private var signUpSuccess = false // <-- Added
    @State private var signUpError: String? = nil // Optional: for error feedback

    let genders = ["Male", "Female", "Other"]
    let goals = ["Weight Loss", "Muscle Gain", "Maintenance", "Detox"]
    let conditions = ["None", "Diabetes", "Hypertension", "Allergies"]

    var body: some View {
        VStack(spacing: 10) {
            Group {
                CustomTextField(label: "Name", text: $name)
                CustomTextField(label: "Email", text: $email)
                CustomTextField(label: "Password", text: $password, isSecure: true)

                VStack(alignment: .leading, spacing: 5) {
                    Text("Date of Birth")
                        .font(.custom("Baloo Bhaijaan 2", size: 14))
                        .padding(.leading, 8)
                    HStack {
                        DatePicker("", selection: $dob, displayedComponents: .date)
                            .labelsHidden()
                        Spacer()
                        Image(systemName: "calendar")
                    }
                    .padding()
                    .frame(width: 300, height: 60)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 4)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
            }

            CustomPicker(label: "Gender", selection: $selectedGender, options: genders)
            CustomPicker(label: "Goal", selection: $selectedGoal, options: goals)
            CustomPicker(label: "Special Condition", selection: $selectedCondition, options: conditions)

            Button(action: {
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if let error = error {
                        print("Sign Up failed:", error.localizedDescription)
                        signUpError = error.localizedDescription // <-- Added
                        signUpSuccess = false // <-- Added
                    } else if let result = result {
                        print("Sign Up success! UID:", result.user.uid)
                        let db = Firestore.firestore()
                        db.collection("users").document(result.user.uid).setData([
                            "name": name,
                            "email": email,
                            "dob": Timestamp(date: dob),
                            "gender": selectedGender,
                            "goal": selectedGoal,
                            "condition": selectedCondition,
                            "createdAt": Timestamp()
                        ]) { err in
                            if let err = err {
                                print("Error saving user profile:", err.localizedDescription)
                                signUpError = err.localizedDescription // <-- Added
                                signUpSuccess = false // <-- Added
                            } else {
                                print("User profile saved to Firestore!")
                                signUpSuccess = true // <-- Added
                                signUpError = nil // <-- Added
                            }
                        }
                    }
                }
            }) {
                Text("Create")
                    .font(.custom("Baloo Bhaijaan 2", size: 16))
                    .padding()
                    .frame(width: 99, height: 55)
                    .background(Color(red: 0.43, green: 0.57, blue: 0.65))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
            }
            .padding(.top, 20)

            // Show success or error message below the button
            if signUpSuccess {
                Text("Your account has been successfully created!")
                    .foregroundColor(.green)
                    .font(.custom("Baloo Bhaijaan 2", size: 16))
                    .padding(.top, 8)
            } else if let error = signUpError {
                Text(error)
                    .foregroundColor(.red)
                    .font(.custom("Baloo Bhaijaan 2", size: 14))
                    .padding(.top, 8)
            }
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
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
                .font(.custom("Baloo Bhaijaan 2", size: 14))
                .padding(.leading, 8) // Adjust value (e.g., 8, 12) as needed

            
            Group {
                if isSecure {
                    SecureField("", text: $text)
                } else {
                    TextField("", text: $text)
                }
            }
            .padding()
            .frame(width: 300)
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
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.custom("Baloo Bhaijaan 2", size: 14))
                .padding(.leading, 8)

            Menu {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        selection = option
                    }) {
                        Text(option)
                    }
                }
            } label: {
                HStack {
                    Text(selection.isEmpty ? "Select" : selection)
                        .foregroundColor(selection.isEmpty ? .gray : .black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(width: 300, height: 55)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 4)
            }
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 20) // Or match padding with your other fields
    }
}
