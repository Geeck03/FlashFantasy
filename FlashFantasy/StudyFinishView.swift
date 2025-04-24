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
                }
                .buttonStyle(.borderedProminent)

                Button("Play Flappy Bird") {
                    showFlappy = true
                }
                .buttonStyle(.bordered)

                Button("Go Back") {
                    onFinish()
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
