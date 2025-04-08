
import Foundation

struct Deck: Identifiable, Codable {
    var id = UUID()
    var name: String
    var description: String
    var flashcards: [Flashcard] = []
}

struct Flashcard: Identifiable, Codable {
    var id = UUID()
    var question: String
    var answer: String
    var easeFactor: Double = 2.5  // Default EF value, ranges from 1.3 to 2.5
    var repetitions: Int = 0     // Number of times this card has been reviewed
    var interval: Int = 1        // Days until next review
    var nextReviewDate: Date?    // Date when the flashcard should be reviewed again
}
