import SwiftUI

struct ContentView: View {
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
                
                NavigationLink(destination: CreateCardsView()) {
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

struct Deck: Identifiable {
    var id = UUID()
    var name: String
    var description: String
}

struct CreateCardsView: View {
    @State private var cardName: String = ""
    @State private var cardDescription: String = ""
    @State private var decks: [Deck] = []  
    @State private var isCreatingNewDeck: Bool = false
    
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
                                let newDeck = Deck(name: cardName, description: cardDescription)
                                decks.append(newDeck)
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
                    List(decks) { deck in
                        VStack(alignment: .leading) {
                            Text(deck.name)
                                .font(.headline)
                            Text(deck.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 5)
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
