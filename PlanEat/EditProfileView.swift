import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var dob = Date()
    @State private var selectedGoal = ""
    @State private var selectedCondition = ""
    @State private var isSaving = false
    @State private var errorText = ""

    private let goals = ["Weight Loss", "Muscle Gain", "Maintenance", "Detox"]
    private let conditions = ["None", "Diabetes", "Hypertension", "Allergies"]

    var body: some View {
        VStack(spacing: 0) {
            // MARK: – Nav Bar
            HStack {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                        Text("Profile")
                            .font(.headline)
                    }
                }
                .foregroundColor(Color(red: 0.43, green: 0.57, blue: 0.65))
                Spacer()
            }
            .padding()

            ScrollView {
                VStack(spacing: 20) {
                    // Name
                    CustomTextField(label: "Name", text: $name)

                    // DOB
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

                    // Goal
                    CustomPicker(label: "Goal", selection: $selectedGoal, options: goals)

                    // Special Condition
                    CustomPicker(label: "Special Condition", selection: $selectedCondition, options: conditions)

                    // Error text
                    if !errorText.isEmpty {
                        Text(errorText)
                            .foregroundColor(.red)
                    }

                    // Save button
                    Button(action: saveProfile) {
                        if isSaving {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(width: 140, height: 44)
                                .background(Color(red: 0.43, green: 0.57, blue: 0.65))
                                .cornerRadius(22)
                        } else {
                            Text("Save")
                                .font(.custom("Baloo Bhaijaan 2", size: 16))
                                .padding()
                                .frame(width: 140)
                                .background(Color(red: 0.43, green: 0.57, blue: 0.65))
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
                        }
                    }
                    .padding(.top, 30)
                }
                .padding()
            }
            Spacer()
        }
        .background(Color(red: 0.89, green: 0.96, blue: 0.97).ignoresSafeArea())
        .onAppear(perform: loadProfile)
    }

    private func loadProfile() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docRef = Firestore.firestore().collection("users").document(uid)
        docRef.getDocument { snapshot, error in
            guard let data = snapshot?.data() else { return }
            name = data["name"] as? String ?? ""
            if let ts = data["dob"] as? Timestamp {
                dob = ts.dateValue()
            }
            selectedGoal = data["goal"] as? String ?? ""
            selectedCondition = data["condition"] as? String ?? ""
        }
    }

    private func saveProfile() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        isSaving = true
        let data: [String: Any] = [
            "name": name,
            "dob": Timestamp(date: dob),
            "goal": selectedGoal,
            "condition": selectedCondition
        ]
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .updateData(data) { error in
                isSaving = false
                if let error = error {
                    errorText = "Failed: \(error.localizedDescription)"
                } else {
                    dismiss()
                }
            }
    }
}
