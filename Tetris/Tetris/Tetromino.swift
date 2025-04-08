//
//  TetrisBlock.swift
//  Tetris
//
//  Created by Moerck, Richard on 4/8/25.
//

import Foundation
import SwiftUI

enum TetrominoType: CaseIterable {
    case I,O, T, L, J, S, Z
    
    var color: Color{
        switch self {
        case .I: return .cyan
        case .O: return .yellow
        case .T: return .purple
        case .L: return .orange
        case .J: return .green
        case .S: return .blue
        case .Z: return .red
        }
    }
    
    var shape: [[Int]]{
        switch self{
        case .I: return [[1,1,1,1]]
        case .O: return [[1,1],[1,1]]
        case .T: return [[0,1,0],[1,1,1]]
        case .L: return [[0,0,1],[1,1,1]]
        case .J: return [[1,0,0],[1,1,1]]
        case .S: return [[0,1,1],[1,1,0]]
        case .Z: return [[1,1,0],[0,1,1]]
        }
    }
}

struct Tetromino {
    var type: TetrominoType
    var x: Int
    var y: Int
    var rotationIndex: Int = 0
    
    var blocks:[[Int]] {
        rotatedShape(type.shape, times: rotationIndex)
    }
    
    private func rotatedShape(_ shape: [[Int]], times: Int) -> [[Int]]{
        var result = shape
        for _ in 0..<times{
            result = rotateClockwise(result)
        }
        return result
    }
    
    private func rotateClockwise(_ matrix: [[Int]]) -> [[Int]]{
        let rows = matrix.count
        let cols = matrix[0].count
        var rotated = Array(repeating: Array(repeating: 0, count: rows), count: cols)
        for i in 0..<rows{
            for j in 0..<cols{
                rotated[j][rows - 1 - i] = matrix[i][j]
            }
        }
        return rotated
    }
}
