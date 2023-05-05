import SwiftUI

struct AddHabitView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var habitsViewModel: HabitsViewModel
    
    @State private var habitName: String = ""
    @State private var goal: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name of habit")) {
                    TextField("Name of habit", text: $habitName)
                }
                
                Section(header: Text("Goal")) {
                    TextField("Goal", text: $goal)
                }
                
                Button(action: {
                    let habit = Habit(title: self.habitName, goal: self.goal, creationDate: Date())
                    self.habitsViewModel.addHabit(habit: habit)
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add Habit")
                }
            }
            .navigationBarTitle(Text("Add Habit"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
            })
        }
    }
}
