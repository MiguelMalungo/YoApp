import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    @ObservedObject var firestoreManager = FirestoreManager()

    @State private var newHabitName: String = ""

    func updateHabit(_ habit: Habit) {
        firestoreManager.updateHabit(habit: habit, userId: firestoreManager.userId!)
    }

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        TextField("New Habit", text: $newHabitName)
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)

                        Button(action: {
                            let habit = Habit(name: newHabitName, streak: 0, lastCompleted: nil)
                            firestoreManager.addHabit(habit: habit, userId: firestoreManager.userId!)
                            newHabitName = ""
                        }) {
                            Text("Add")
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color.black)
                                .cornerRadius(8)
                        }
                    }
                    .padding()

                    List {
                        ForEach(firestoreManager.habits) { habit in
                            HabitRow(firestoreManager: firestoreManager, habit: habit, updateHabit: updateHabit)
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                firestoreManager.deleteHabit(habit: firestoreManager.habits[index], userId: firestoreManager.userId!)
                            }
                        }
                    }
                    Spacer()
                }

                VStack {
                    Spacer()
                    Image("logo3") // Replace with your actual logo image name
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200) // Adjust the size of the image here
                }
                .padding(.bottom, 16)
            }
            .navigationTitle("Yo! Let in good habits!")
            .background(
                Image("backgroundImageName") // Replace with your actual image name
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: 200, height: 200)
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
