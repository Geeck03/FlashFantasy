//
//  PostDeckCompletionView.swift
//  FlashFantasy
//
//  Created by Kevin Nguyen on 4/24/25.
//


import SwiftUI

struct StudyFinishView: View {
    var onFinish: () -> Void
    @State private var showTetris: Bool = false
    @State private var showFlappy: Bool = false
    @State private var showButton: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("Great job!")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)

                Text("What would you like to do next?")
                    .font(.title2)

                Button("Play Tetris") {
                    showTetris = true
                    showButton = false
                }
                .buttonStyle(.borderedProminent)
                .disabled(!showButton)
                .opacity(showButton ? 1.0 : 0.5)

                Button("Play Flappy Bird") {
                    showFlappy = true
                    showButton = false
                }
                .buttonStyle(.borderedProminent)
                .disabled(!showButton)
                .opacity(showButton ? 1.0 : 0.5)

                Button("Go Back") {
                    onFinish()
                    showButton = true
                }
                .foregroundColor(.red)
            }
            .padding()

            // Navigate to games
            .navigationDestination(isPresented: $showTetris) {
                TetrisView(navigateToTetris: $showTetris)
            }

            .navigationDestination(isPresented: $showFlappy) {
            }
        }
    }
}
