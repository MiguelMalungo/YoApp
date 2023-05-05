import SwiftUI

struct HabitRow: View {
    @ObservedObject var firestoreManager: FirestoreManager
    let habit: Habit
    let updateHabit: (Habit) -> Void
    @State private var showEditHabitView = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    if habit.lastCompleted != nil {
                        Image(systemName: "checkmark.square")
                    }
                    Text(habit.name)
                        .font(.headline)
                        .onTapGesture {
                            showEditHabitView.toggle()
                        }
                }
                
                if habit.streak > 0 {
                    Text("You have done this \(habit.streak) days in a row! \(streakMessage(streak: habit.streak)) Yo!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Button(action: {
                var updatedHabit = habit
                
                if habit.lastCompleted != nil {
                    updatedHabit.streak = max(0, habit.streak - 1)
                    updatedHabit.lastCompleted = nil
                } else {
                    let now = Date()
                    if let lastCompleted = habit.lastCompleted {
                        let calendar = Calendar.current
                        let dayDifference = calendar.dateComponents([.day], from: lastCompleted, to: now).day
                        
                        if dayDifference! > 1 {
                            updatedHabit.streak = 1
                        } else {
                            updatedHabit.streak += 1
                        }
                        updatedHabit.lastCompleted = now
                    } else {
                        updatedHabit.streak = 1
                        updatedHabit.lastCompleted = now
                    }
                }
                updateHabit(updatedHabit)
            }) {
                Text(habit.lastCompleted != nil ? "Undo" : "Done")
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.orange)
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal)
        .sheet(isPresented: $showEditHabitView) {
            EditHabitView(habit: habit) { updatedHabit in
                updateHabit(updatedHabit)
            }
        }
    }
    
    func streakMessage(streak: Int) -> String {
        switch streak {
        case 1:
            return "Thats a START"
        case 2:
            return "GOOD"
        case 3:
            return "VERY GOOD"
        case 5:
            return "GREAT"
        case 7...:
            return "EXCELLENT"
        default:
            return ""
        }
    }

}

struct HabitRow_Previews: PreviewProvider {
    static var previews: some View {
        let habit = Habit(name: "Test Habit", streak: 5, lastCompleted: Date())
        let firestoreManager = FirestoreManager()
        HabitRow(firestoreManager: firestoreManager, habit: habit) { updatedHabit in
            // do something with updated habit
        }
    }
}
