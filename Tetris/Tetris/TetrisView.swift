//
//  TetrisView.swift
//  Tetris
//
//  Created by Moerck, Richard on 4/8/25.
//

import SwiftUI

struct TetrisView: View {
    @StateObject var viewModel = TetrisViewModel()
    
    var body: some View {
        VStack(spacing: 10){
            Text("Score: \(viewModel.score)")
                .font(.headline)
            
            GeometryReader { geo in
                let blockSize = geo.size.width / CGFloat(viewModel.cols)
                ZStack {
                    ForEach(0..<viewModel.rows, id: \.self) { y in
                        ForEach(0..<viewModel.cols, id: \.self) { x in
                            Rectangle()
                                .stroke(Color.gray, lineWidth: 0.5)
                                .background(
                                    (viewModel.grid[y][x] ?? .clear)
                                        .frame(width: blockSize, height: blockSize)
                                )
                                .position(x: CGFloat(x) * blockSize + blockSize / 2, y: CGFloat(y) * blockSize + blockSize / 2)
                        }
                    }
                    
                    if let current = viewModel.current{
                        ForEach(0..<current.blocks.count, id: \.self){ y in
                            ForEach(0..<current.blocks[y].count, id: \.self){ x in
                                if current.blocks[y][x] == 1 {
                                    Rectangle()
                                        .fill(current.type.color)
                                        .frame(width: blockSize, height: blockSize)
                                        .position(x: CGFloat(x + current.x) * blockSize + blockSize / 2, y: CGFloat(y + current.y) * blockSize + blockSize / 2)
                                }
                            }
                        }
                    }
                }
            }
            .aspectRatio(0.5, contentMode: .fit)
            .border(Color.black)
            
            HStack(spacing: 15){
                Button("◀️"){viewModel.moveLeft()}
                Button("🔄"){viewModel.rotate()}
                Button("▶️"){viewModel.moveRight()}
                Button("⬇️"){viewModel.moveDown()}
                Button("⏬"){viewModel.drop()}
            }
            
            HStack(spacing: 20){
                Button(viewModel.isPaused ? "Resume" : "Pause"){
                    viewModel.pauseResume()
                }
                Button("Restart"){
                    viewModel.restart()
                }
            }
            
            if viewModel.isGameOver{
                Text("Game Over")
                    .font(.title)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}
