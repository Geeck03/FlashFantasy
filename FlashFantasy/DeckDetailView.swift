
import SwiftUI

struct DeckDetailView: View {
    @ObservedObject var decksManager: DecksManager
    var deck: Deck
    
    @State private var question: String = ""
    @State private var answer: String = ""
    
    var body: some View {
        VStack {
            Text("Deck: \(deck.name)")
                .font(.custom("Papyrus", size: 24))
                .padding()
            
            VStack {
                TextField("Enter Question", text: $question)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Enter Answer", text: $answer)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Add Flashcard") {
                    if !question.isEmpty && !answer.isEmpty {
                        decksManager.addFlashcard(to: deck, question: question, answer: answer)
                        question = ""
                        answer = ""
                    }
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Spacer()
            }
            .padding()
            
            List {
                ForEach(deck.flashcards) { flashcard in
                    VStack(alignment: .leading) {
                        Text(flashcard.question)
                            .font(.custom("Papyrus", size: 20))
                            .fontWeight(.bold)
                        Text(flashcard.answer)
                            .font(.custom("Papyrus", size: 18))
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 5)
                }
                .onDelete(perform: deleteFlashcard)
            }
        }
        .navigationTitle("Flashcards")
        .padding()
    }
    
    private func deleteFlashcard(at offsets: IndexSet) {
        if let index = offsets.first {
            if let deckIndex = decksManager.decks.firstIndex(where: { $0.id == deck.id }) {
                decksManager.decks[deckIndex].flashcards.remove(at: index)
                decksManager.saveDecks()
            }
        }
    }
}
