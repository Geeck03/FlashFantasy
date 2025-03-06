//
//  ContentView.swift
//  FlashFantasy
//
//  Created by Ethan Jiang on 2/18/25.
//

import SwiftUI

struct ContentView: View {
    @State private var fbg: Double = 1.0

    var body: some View {
        VStack(spacing: 20) {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
        }
        VStack {
               Text("Flashcards Between Games: \(Int(fbg))")
               Slider(value: $fbg, in: 1...20, step: 1)
                   .padding()
           }
    }
}



#Preview {
    ContentView()
}

