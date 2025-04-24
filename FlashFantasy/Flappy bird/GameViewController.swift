import UIKit
import SpriteKit

class GameViewController: UIViewController {
    private var gameScene: GameScene?

    override func viewDidLoad() {
        super.viewDidLoad()

        let skView = SKView(frame: self.view.bounds)
        self.view = skView

        let scene = GameScene(size: view.bounds.size)
        scene.scaleMode = .resizeFill
        gameScene = scene
        skView.presentScene(scene)
    }

    
    func startGame() {
        gameScene?.setupScene()
        gameScene?.startSpawningPipes()
    }
}
