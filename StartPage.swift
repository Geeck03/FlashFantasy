//
//  StartPage.swift
//  FlashFantasy
//

import SwiftUI


struct StartPage: View {
    @StateObject private var decksManager = DecksManager()
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.black]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()
                
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    Text("Flash Fantasy")
                        .font(.custom("Papyrus", size: 48))
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                        .shadow(color: .black, radius: 5, x: 0, y: 2)
                        .padding(.bottom, 20)
                    
                    NavigationLink(destination: StudyView()) {
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
                    
                    NavigationLink(destination: QuestView()) {
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
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}
