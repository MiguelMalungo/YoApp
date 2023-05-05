import Foundation
import FirebaseAuth

class AuthManager: ObservableObject {
    @Published var isSignedIn: Bool = false
    
    init() {
        Auth.auth().addStateDidChangeListener { auth, user in
            self.isSignedIn = user != nil
        }
        signInAnonymously()
    }
    
    func signInAnonymously() {
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                print("Error signing in anonymously: \(error)")
                return
            }
            print("Signed in anonymously with user: \(authResult?.user.uid ?? "")")
        }
    }
}
