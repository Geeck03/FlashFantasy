
import Foundation

class DecksManager: ObservableObject {
    @Published var decks: [Deck] = []
    private let decksKey = "savedDecks"
    
    init() {
        loadDecks()
    }
    
    func addDeck(name: String, description: String) {
        let newDeck = Deck(name: name, description: description)
        decks.append(newDeck)
        saveDecks()
    }
    
    func removeDeck(at offsets: IndexSet) {
        decks.remove(atOffsets: offsets)
        saveDecks()
    }
    
    func addFlashcard(to deck: Deck, question: String, answer: String) {
        if let index = decks.firstIndex(where: { $0.id == deck.id }) {
            let newFlashcard = Flashcard(question: question, answer: answer)
            decks[index].flashcards.append(newFlashcard)
            saveDecks()
        }
    }
    
    func saveDecks() {
        if let encodedData = try? JSONEncoder().encode(decks) {
            UserDefaults.standard.set(encodedData, forKey: decksKey)
        }
    }
    
    private func loadDecks() {
        if let data = UserDefaults.standard.data(forKey: decksKey),
           let decodedDecks = try? JSONDecoder().decode([Deck].self, from: data) {
            self.decks = decodedDecks
        }
    }
}
