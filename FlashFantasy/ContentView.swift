
import SwiftUI



// MARK: - Start Page with Fantasy Vibe (No changes needed)
struct StartPage: View {
    @StateObject private var decksManager = DecksManager()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background: use an image named "fantasyBackground" or uncomment the gradient below if you prefer.
                Image("fantasyBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(0.8)
                
                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.black]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()
                
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    // Fantasy title
                    Text("Flash Fantasy")
                        .font(.custom("Papyrus", size: 48))
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                        .shadow(color: .black, radius: 5, x: 0, y: 2)
                        .padding(.bottom, 20)
                    
                    // Navigation buttons with a gradient background
                    NavigationLink(destination: StudyDeckSelectionView(decksManager: decksManager)) {
                        Text("Start Studying")
                            .font(.custom("Papyrus", size: 24))
                            .frame(maxWidth: .infinity)
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
                    
                    NavigationLink(destination: CreateCardsView(decksManager: decksManager)) {
                        Text("Create Cards")
                            .font(.custom("Papyrus", size: 24))
                            .frame(maxWidth: .infinity)
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
                    
                    NavigationLink(destination: Quest()) {
                        Text("Quests")
                            .font(.custom("Papyrus", size: 24))
                            .frame(maxWidth: .infinity)
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
                    
                    NavigationLink(destination: SettingView()) {
                        Text("Settings")
                            .font(.custom("Papyrus", size: 24))
                            .frame(maxWidth: .infinity)
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
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Create Cards View (No changes needed)
struct CreateCardsView: View {
    @State private var cardName: String = ""
    @State private var cardDescription: String = ""
    @State private var isCreatingNewDeck: Bool = false
    
    @ObservedObject var decksManager: DecksManager
    
    var body: some View {
        VStack {
            if isCreatingNewDeck {
                VStack {
                    Text("Create a Flash Card Deck")
                        .font(.custom("Papyrus", size: 30))
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
                        NavigationLink(destination: DeckDetailView(decksManager: decksManager, deck: deck)) {
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
                    .onDelete { indexSet in
                        decksManager.removeDeck(at: indexSet)
                    }
                }
            }
        }
        .navigationTitle("Decks")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isCreatingNewDeck = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

struct QuestView: View {
    var body: some View {
        Text("Quests - Work in Progress")
            .font(.custom("Papyrus", size: 30))
            .padding()
    }
}

// MARK: - Entry Point and Preview
struct ContentView: View {
    var body: some View {
        StartPage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


