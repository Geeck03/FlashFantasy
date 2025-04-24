import SwiftUI

struct StudyDeckSelectionView: View {
    @ObservedObject var decksManager: DecksManager  // Observing the decks manager to get the saved data
    @State private var selectedDeck: Deck? = nil  // To keep track of the selected deck
    
    var body: some View {
        VStack {
            Text("Select a Deck to Study")
                .font(.custom("Papyrus", size: 30))
                .padding()
            
            // List of all decks in the manager
            List(decksManager.decks) { deck in
                // Only enable button if deck has flashcards
                if deck.flashcards.isEmpty {
                    // Show the deck name with a "No Flashcards" message
                    VStack(alignment: .leading) {
                        Text(deck.name)
                            .font(.custom("Papyrus", size: 22))
                            .foregroundColor(.gray)
                        Text("(No flashcards)")
                            .font(.custom("Papyrus", size: 16))
                            .foregroundColor(.red)
                    }
                    .padding(.vertical, 5)
                } else {
                    // For decks with flashcards, use NavigationLink
                    NavigationLink(destination: StudyFlashcardsView(deck: deck, decksManager: decksManager)) {
                        VStack(alignment: .leading) {
                            Text(deck.name)
                                .font(.custom("Papyrus", size: 22))
                                .fontWeight(.bold)
                            Text(deck.description)
                                .font(.custom("Papyrus", size: 18))
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
        }
        .navigationTitle("Deck Selection")
    }
}
