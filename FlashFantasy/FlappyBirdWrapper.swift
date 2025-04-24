//
//  FlappyBirdWrapper.swift
//  FlashFantasy
//
//  Created by Kevin Nguyen on 4/24/25.
//

import UIKit
import SwiftUI
struct FlappyBirdWrapper: UIViewControllerRepresentable {
    class Coordinator {
        var hasStartedGame = false
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    func makeUIViewController(context: Context) -> GameViewController {
        return GameViewController()
    }

    func updateUIViewController(_ uiViewController: GameViewController, context: Context) {
        if !context.coordinator.hasStartedGame {
            uiViewController.startGame()
            context.coordinator.hasStartedGame = true
        }
    }
}

