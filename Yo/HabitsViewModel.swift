import Foundation
import Firebase

class HabitsViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    private var db = Firestore.firestore()
    private var userId = ""
    
    init() {
        if let user = Auth.auth().currentUser {
            self.userId = user.uid
            fetchData()
        }
    }
    
    func fetchData() {
        db.collection("users").document(userId).collection("habits").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.habits = documents.map { queryDocumentSnapshot -> Habit in
                let data = queryDocumentSnapshot.data()
                
                let id = queryDocumentSnapshot.documentID
                let title = data["title"] as? String ?? ""
                let goal = data["goal"] as? String ?? ""
                let creationDate = data["creationDate"] as? Date ?? Date()
                let completedDates = data["completedDates"] as? [Timestamp] ?? []
                let completed = !completedDates.isEmpty
                
                return Habit(id: id, title: title, goal: goal, creationDate: creationDate, completedDates: completedDates)
            }
        }
    }
    
    func addHabit(habit: Habit) {
        do {
            let _ = try db.collection("users").document(userId).collection("habits").addDocument(from: habit)
        } catch {
            print(error)
        }
    }
    
    func updateHabit(habit: Habit) {
        if let id = habit.id {
            do {
                try db.collection("users").document(userId).collection("habits").document(id).setData(from: habit)
            } catch {
                print(error)
            }
        }
    }
    
    func deleteHabit(habit: Habit) {
        if let id = habit.id {
            db.collection("users").document(userId).collection("habits").document(id).delete() { error in
                if let error = error {
                    print("Error removing document: \(error)")
                }
            }
        }
    }
    
    func toggleCompleted(habit: Habit) {
        if let id = habit.id {
            let completedDates = habit.completedDates + [Timestamp(date: Date())]
            db.collection("users").document(userId).collection("habits").document(id).updateData(["completedDates": completedDates])
        }
    }
    
    func resetCompletedDates(habit: Habit) {
        if let id = habit.id {
            db.collection("users").document(userId).collection("habits").document(id).updateData(["completedDates": []])
        }
    }
    
    func isTodayCompleted(habit: Habit) -> Bool {
        let today = Date()
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: today)
        
        if let lastCompletedDate = habit.completedDates.last?.dateValue() {
            let startOfLastCompletedDate = calendar.startOfDay(for: lastCompletedDate)
            if startOfLastCompletedDate == startOfToday {
                return true
            }
        }
        
        return false
    }
}
