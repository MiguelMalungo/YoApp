import SwiftUI

struct EditHabitView: View {
    @Environment(\.presentationMode) var presentationMode
    let habit: Habit
    let updateHabit: (Habit) -> Void
    @State private var habitName: String
    
    init(habit: Habit, updateHabit: @escaping (Habit) -> Void) {
        self.habit = habit
        self.updateHabit = updateHabit
        _habitName = State(initialValue: habit.name)
    }
    
    var body: some View {
        NavigationView {
            
            Form {
            
                Section {
                    TextField("Habit Name", text: $habitName)
                }
                
            }
            .navigationTitle("Edit Habit")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                var updatedHabit = habit
                updatedHabit.name = habitName
                updateHabit(updatedHabit)
                presentationMode.wrappedValue.dismiss()
                
            })
        }
    }
    
}

struct EditHabitView_Previews: PreviewProvider {
    static var previews: some View {
        EditHabitView(habit: Habit(name: "Test Habit", streak: 5, lastCompleted: Date())) { updatedHabit in
            // do something with updated habit
        }
    }
}
