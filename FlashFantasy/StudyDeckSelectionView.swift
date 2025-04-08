
import SwiftUI

struct StudyDeckSelectionView: View {
    @ObservedObject var decksManager: DecksManager
    @State private var selectedDeck: Deck?
    
    var body: some View {
        VStack {
            Text("Select a Deck to Study")
                .font(.custom("Papyrus", size: 30))
                .padding()
            
            List(decksManager.decks) { deck in
                Button(action: {
                    selectedDeck = deck
                }) {
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
            
            if let selectedDeck = selectedDeck {
                NavigationLink(destination: StudyFlashcardsView(deck: selectedDeck, decksManager: decksManager)) {
                    Text("Start Studying \(selectedDeck.name)")
                        .font(.custom("Papyrus", size: 24))
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                           startPoint: .leading,
                                           endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }
            }
        }
        .navigationTitle("Deck Selection")
    }
}
