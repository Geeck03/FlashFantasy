
import SwiftUI

struct StudyFlashcardsView: View {
    var deck: Deck
    @ObservedObject var decksManager: DecksManager  // Add this line
    @State private var currentFlashcard: Flashcard?
    @State private var flashcards: [Flashcard]
    @State private var currentIndex: Int = 0
    @State private var showAnswer: Bool = false  // Track whether to show the answer
    
    init(deck: Deck, decksManager: DecksManager) {
        self.deck = deck
        self._decksManager = ObservedObject(wrappedValue: decksManager)  // Initialize the decksManager
        self._flashcards = State(initialValue: deck.flashcards.shuffled())
    }
    
    var body: some View {
        VStack {
            if let flashcard = currentFlashcard {
                // Question Text
                Text(flashcard.question)
                    .font(.custom("Papyrus", size: 24))
                    .fontWeight(.bold)
                    .padding()
                    .onTapGesture {
                        // Show answer when the user taps the question
                        showAnswer = true
                    }
                
                // Conditional answer visibility
                if showAnswer {
                    Text(flashcard.answer)
                        .font(.custom("Papyrus", size: 20))
                        .padding()
                }
                
                Spacer()
                
                // Vertical buttons for Easy, Medium, Hard
                VStack(spacing: 20) {
                    Button("Easy") {
                        handleFlashcardDifficulty("Easy")
                    }
                    .buttonStyle(GradientButtonStyle())
                    .frame(maxWidth: .infinity) // Full width
                    
                    Button("Medium") {
                        handleFlashcardDifficulty("Medium")
                    }
                    .buttonStyle(GradientButtonStyle())
                    .frame(maxWidth: .infinity) // Full width
                    
                    Button("Hard") {
                        handleFlashcardDifficulty("Hard")
                    }
                    .buttonStyle(GradientButtonStyle())
                    .frame(maxWidth: .infinity) // Full width
                }
                .padding([.leading, .trailing], 20)
            }
            
        }
        .onAppear {
            showNextFlashcard()
        }
        .navigationTitle("Studying: \(deck.name)")
    }
    
    private func handleFlashcardDifficulty(_ difficulty: String) {
        guard let flashcard = currentFlashcard else { return }
        
        // Update flashcard's review schedule based on difficulty
        var newEaseFactor = flashcard.easeFactor
        var newInterval = flashcard.interval
        var newRepetitions = flashcard.repetitions
        
        // Adjust ease factor and interval based on difficulty
        switch difficulty {
        case "Easy":
            newRepetitions += 1
            newEaseFactor = max(1.3, newEaseFactor + 0.2)  // Increase EF (no higher than 2.5)
            newInterval = Int(Double(newInterval) * 1.3)   // Increase interval by 30%
        case "Medium":
            newRepetitions += 1
            newEaseFactor = max(1.3, newEaseFactor + 0.1)  // Slightly increase EF
        case "Hard":
            newRepetitions = max(1, newRepetitions - 1)    // Decrease repetitions (make it harder)
            newEaseFactor = max(1.3, newEaseFactor - 0.1)  // Decrease EF if Hard
            newInterval = max(1, newInterval - 1)           // Decrease interval
        default:
            break
        }
        
        // Apply the updated values
        if let deckIndex = decksManager.decks.firstIndex(where: { $0.id == deck.id }),
           let flashcardIndex = decksManager.decks[deckIndex].flashcards.firstIndex(where: { $0.id == flashcard.id }) {
            // Update the flashcard
            decksManager.decks[deckIndex].flashcards[flashcardIndex].easeFactor = newEaseFactor
            decksManager.decks[deckIndex].flashcards[flashcardIndex].interval = newInterval
            decksManager.decks[deckIndex].flashcards[flashcardIndex].repetitions = newRepetitions
            
            // Schedule the next review date
            let nextReviewDate = Calendar.current.date(byAdding: .day, value: newInterval, to: Date())!
            decksManager.decks[deckIndex].flashcards[flashcardIndex].nextReviewDate = nextReviewDate
            
            decksManager.saveDecks()  // Save the updated flashcards
        }
        
        // Proceed to the next flashcard
        showNextFlashcard()
    }

    private func showNextFlashcard() {
        if currentIndex < flashcards.count {
            currentFlashcard = flashcards[currentIndex]
            showAnswer = false // Reset showAnswer when showing the next flashcard
            currentIndex += 1
        } else {
            // You finished all flashcards
            print("All flashcards completed!")
        }
    }
}
