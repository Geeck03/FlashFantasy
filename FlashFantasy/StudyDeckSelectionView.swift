import SwiftUI

struct StudyDeckSelectionView: View {
    @ObservedObject var decksManager: DecksManager
    @State private var selectedDeck: Deck? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Select a Deck to Study")
                    .font(.custom("Papyrus", size: 30))
                    .padding()
                
                List(decksManager.decks) { deck in
                    // Only enable button if deck has flashcards
                    if !deck.flashcards.isEmpty {
                        NavigationLink(value: deck) {
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
                    } else {
                        VStack(alignment: .leading) {
                            Text(deck.name)
                                .font(.custom("Papyrus", size: 22))
                                .foregroundColor(.gray)
                            Text("(No flashcards)")
                                .font(.custom("Papyrus", size: 16))
                                .foregroundColor(.red)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .navigationTitle("Deck Selection")
            .navigationDestination(for: Deck.self) { deck in
                StudyFlashcardsView(deck: deck, decksManager: decksManager)
            }
        }
    }
}
