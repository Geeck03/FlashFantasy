import SwiftUI

struct TetrisView: View {
    @StateObject var viewModel = TetrisViewModel()
    @Binding var navigateToTetris: Bool

    init(navigateToTetris: Binding<Bool>) {
        self._navigateToTetris = navigateToTetris
    }

    var body: some View {
        
        ZStack {
            Image("cob")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                Text("Score: \(viewModel.score)")
                    .font(.custom("Paypyrus", size: 25))
                    .font(.headline)
                    .capsuleButtonStyle(color: .gray)
                
                GeometryReader { geo in
                    let blockSize = geo.size.width / CGFloat(viewModel.cols)
                    ZStack {
                        
                        LinearGradient(colors: [.red, .orange, .yellow], startPoint:.top, endPoint:.bottom)
                        
                        ForEach(0..<viewModel.rows, id: \.self) { y in
                            ForEach(0..<viewModel.cols, id: \.self) { x in
                                Rectangle()
                                    .fill(viewModel.grid[y][x] ?? .clear)
                                    .frame(width: blockSize, height: blockSize)
                                    .position(
                                        x: CGFloat(x) * blockSize + blockSize / 2,
                                        y: CGFloat(y) * blockSize + blockSize / 2
                                    )
                            }
                        }
                        
                        if let current = viewModel.current {
                            ForEach(0..<current.blocks.count, id: \.self) { y in
                                ForEach(0..<current.blocks[y].count, id: \.self) { x in
                                    if current.blocks[y][x] == 1 {
                                        Rectangle()
                                            .fill(current.type.color)
                                            .frame(width: blockSize, height: blockSize)
                                            .position(
                                                x: CGFloat(x + current.x) * blockSize + blockSize / 2,
                                                y: CGFloat(y + current.y) * blockSize + blockSize / 2
                                            )
                                    }
                                }
                            }
                        }
                    }
                }
                .aspectRatio(0.5, contentMode: .fit)
                .border(Color.black)
                
                HStack(spacing: 15) {
                    Button("◀️") { viewModel.moveLeft() }
                    Button("🔄") { viewModel.rotate() }
                    Button("▶️") { viewModel.moveRight() }
                    Button("⬇️") { viewModel.moveDown() }
                }
                .font(.custom("Paypyrus", size: 12))
                .capsuleButtonStyle()
                
                HStack(spacing: 20) {
                    Button(viewModel.isPaused ? "Resume" : "Pause") {
                        viewModel.pauseResume()
                    }
                    .font(.custom("Paypyrus", size: 25))
                    .capsuleButtonStyle()
                    
                    Button("Restart") {
                        viewModel.restart()
                    }
                    .font(.custom("Paypyrus", size: 25))
                    .capsuleButtonStyle()
                }
                
                if viewModel.isGameOver {
                    Text("Game Over")
                        .font(.custom("Paypyrus", size: 25))
                        .font(.title)
                        .foregroundColor(.red)
                    Button("Go Back") {
                        navigateToTetris = false
                    }
                    .font(.custom("Paypyrus", size: 25))
                    .capsuleButtonStyle()
                }
            }
            .padding()
        }
    }
}
