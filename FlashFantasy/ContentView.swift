import SwiftUI

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
        
    
    private func saveDecks() {
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


struct Deck: Identifiable, Codable {
    var id = UUID()
    var name: String
    var description: String
}

struct ContentView: View {
    @StateObject private var decksManager = DecksManager()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Flash Fantasy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
                
                NavigationLink(destination: StudyView()) {
                    Text("Start Studying")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: CreateCardsView(decksManager: decksManager)) {
                    Text("Create Cards")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: QuestView()) {
                    Text("Quests")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct StudyView: View {
    var body: some View {
        Text("WIP")
    }
}

struct CreateCardsView: View {
    @State private var cardName: String = ""
    @State private var cardDescription: String = ""
    @State private var isCreatingNewDeck: Bool = false
    
    @ObservedObject var decksManager: DecksManager
    
    var body: some View {
        NavigationView {
            VStack {
                if isCreatingNewDeck {
                    VStack {
                        Text("Create a Flash Card Deck")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()

                        TextField("Enter Deck Name", text: $cardName)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Enter Deck Description", text: $cardDescription)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button("Add Deck") {
                            if !cardName.isEmpty && !cardDescription.isEmpty {
                                decksManager.addDeck(name: cardName, description: cardDescription)
                                cardName = ""
                                cardDescription = ""
                                isCreatingNewDeck = false
                            }
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)

                        Spacer()
                    }
                    .padding()
                } else {
                    List {
                        ForEach(decksManager.decks) { deck in
                            VStack(alignment: .leading) {
                                Text(deck.name)
                                    .font(.headline)
                                Text(deck.description)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 5)
                        }
                        .onDelete { indexSet in
                            decksManager.removeDeck(at: indexSet)
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Decks")
            .navigationBarItems(trailing: Button(action: {
                isCreatingNewDeck = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(.blue)
            })
        }
    }
}


struct QuestView: View {
    var body: some View {
        Text("WIP")
    }
}

#Preview {
    ContentView()
}
