
import SwiftUI

struct StudyFlashcardsView: View {
    var deck: Deck
    @ObservedObject var decksManager: DecksManager
    @State private var currentFlashcard: Flashcard?
    @State private var flashcards: [Flashcard]
    @State private var currentIndex: Int = 0
    @State private var showAnswer: Bool = false  // Track whether to show the answer
    @State private var nextReviewInfo: String? = nil
    @State private var intervalPreviews: [String: String] = [:]


    
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
                    Button(action: { handleFlashcardDifficulty("Easy") }) {
                        Text("Easy (\(intervalPreviews["Easy"] ?? ""))")
                    }
                    .buttonStyle(GradientButtonStyle())
                    .frame(maxWidth: .infinity)
                    
                    Button(action: { handleFlashcardDifficulty("Medium") }) {
                        Text("Medium (\(intervalPreviews["Medium"] ?? ""))")
                    }
                    .buttonStyle(GradientButtonStyle())
                    .frame(maxWidth: .infinity)
                    
                    Button(action: { handleFlashcardDifficulty("Hard") }) {
                        Text("Hard (\(intervalPreviews["Hard"] ?? ""))")
                    }
                    .buttonStyle(GradientButtonStyle())
                    .frame(maxWidth: .infinity)
                }
                .padding([.leading, .trailing], 20)
            }
            
        }
        .onAppear {
            showNextFlashcard()
        }
        .navigationTitle("Studying: \(deck.name)")
    }
    
    private func updateIntervalPreviews(for flashcard: Flashcard) {
        var previews: [String: String] = [:]
        
        let difficulties = ["Easy", "Medium", "Hard"]
        
        for difficulty in difficulties {
            var interval = flashcard.interval
            var ef = flashcard.easeFactor
            
            switch difficulty {
            case "Easy":
                interval = Int(Double(interval) * 1.3)
                ef += 0.2
            case "Medium":
                ef += 0.1
            case "Hard":
                interval = max(1, interval - 1)
                ef -= 0.1
            default:
                break
            }
            
            ef = max(1.3, min(ef, 2.5))
            
            // Generate time preview
            let timeDesc: String
            if interval < 1 {
                timeDesc = "+10 mins"
            } else if interval == 1 {
                timeDesc = "+1 day"
            } else {
                timeDesc = "+\(interval) days"
            }
            
            previews[difficulty] = timeDesc
        }
        
        self.intervalPreviews = previews
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
            newInterval = Int(Double(newInterval) * 2.0)   // Increase interval by 200%
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
        // Apply updated values to the flashcard
        if let deckIndex = decksManager.decks.firstIndex(where: { $0.id == deck.id }),
           let flashcardIndex = decksManager.decks[deckIndex].flashcards.firstIndex(where: { $0.id == flashcard.id }) {
            // Update the flashcard with the new values
            decksManager.decks[deckIndex].flashcards[flashcardIndex].easeFactor = newEaseFactor
            decksManager.decks[deckIndex].flashcards[flashcardIndex].interval = newInterval
            decksManager.decks[deckIndex].flashcards[flashcardIndex].repetitions = newRepetitions

            // Schedule the next review date based on the updated interval
            let nextReviewDate = Calendar.current.date(byAdding: .day, value: newInterval, to: Date())!
            decksManager.decks[deckIndex].flashcards[flashcardIndex].nextReviewDate = nextReviewDate

            decksManager.saveDecks()  // Save updated decks
        }
        // Proceed to the next flashcard
        showNextFlashcard()
    }

    private func showNextFlashcard() {
        if currentIndex < flashcards.count {
            currentFlashcard = flashcards[currentIndex]
            showAnswer = false
            nextReviewInfo = nil
            updateIntervalPreviews(for: flashcards[currentIndex])
            currentIndex += 1
        } else {
            print("All flashcards completed!")
        }
    }
}
