import SwiftUI
import FirebaseAuth

class SessionManager: ObservableObject {
    @Published var isLoggedIn: Bool = false

    init() {
        checkLogin()
    }

    func checkLogin() {
        isLoggedIn = Auth.auth().currentUser != nil
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
        } catch {
            print("Error signing out:", error.localizedDescription)
        }
    }
}
