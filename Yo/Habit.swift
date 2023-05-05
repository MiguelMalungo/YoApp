import FirebaseFirestoreSwift
import Foundation

struct Habit: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var streak: Int
    var lastCompleted: Date?
    var lastCompletedDate: Date? // New property to store just the date without the time

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case streak
        case lastCompleted
        case lastCompletedDate
    }
}
