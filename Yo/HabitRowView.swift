import SwiftUI

struct HabitRowView: View {
    @ObservedObject var habitsViewModel: HabitsViewModel
    var habit: Habit
    
    var body: some View {
        HStack {
            Text(habit.title)
            Spacer()
            Button(action: {
                habitsViewModel.toggleCompleted(habit: habit)
            }) {
                Image(systemName: habit.completed ? "checkmark.square" : "square")
            }
        }
    }
}
