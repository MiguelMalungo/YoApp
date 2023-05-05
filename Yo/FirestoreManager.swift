import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreManager: ObservableObject {
    private var db = Firestore.firestore()
    
    @Published var userId: String?
    @Published var habits: [Habit] = []
    
    init() {
        setupFirebaseAuth()
        if let userId = self.userId {
            readHabits(userId: userId)
        }
    }
    
    func setupFirebaseAuth() {
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                print("Error signing in anonymously: \(error)")
            } else {
                self.userId = authResult?.user.uid
                self.readHabits(userId: self.userId!)
            }
        }
    }
    
    func addHabit(habit: Habit, userId: String) {
        do {
            _ = try db.collection("users").document(userId).collection("habits").addDocument(from: habit)
        } catch let error {
            print("Error writing new habit to Firestore: \(error)")
        }
    }
    
    func deleteHabit(habit: Habit, userId: String) {
        if let habitId = habit.id {
            db.collection("users").document(userId).collection("habits").document(habitId).delete { error in
                if let error = error {
                    print("Error removing document: \(error)")
                }
            }
        }
    }
    
    func updateHabit(habit: Habit, userId: String) {
        if let habitId = habit.id {
            var habitData: [String: Any] = [
                "name": habit.name,
                "streak": habit.streak
            ]
            
            if let lastCompleted = habit.lastCompleted {
                habitData["lastCompleted"] = lastCompleted
            } else {
                habitData["lastCompleted"] = FieldValue.delete()
            }
            
            db.collection("users").document(userId).collection("habits").document(habitId).updateData(habitData) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                }
            }
        }
    }


    func readHabits(userId: String) {
        db.collection("users").document(userId).collection("habits").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching habits: \(error!)")
                return
            }
            
            self.habits = documents.compactMap { queryDocumentSnapshot -> Habit? in
                return try? queryDocumentSnapshot.data(as: Habit.self)
            }
        }
    }
}
