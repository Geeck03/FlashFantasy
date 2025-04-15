//
//  TetrisViewModel.swift
//  Tetris
//
//  Created by Moerck, Richard on 4/8/25.
//

import Foundation
import SwiftUI

class TetrisViewModel: ObservableObject{
    let rows = 20
    let cols = 10
    
    @Published var grid: [[Color?]]
    @Published var current: Tetromino?
    @Published var isPaused = false
    @Published var isGameOver = false
    @Published var score = 0
    
    private var timer: Timer?
    
    init(){
        grid = Array(repeating: Array(repeating: nil, count: cols), count: rows)
        spawnNewTetromino()
        startTimer()
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){ _ in
            if !self.isPaused && !self.isGameOver{
                self.moveDown()
            }
        }
    }
    
    func pauseResume(){
        isPaused.toggle()
    }
    
    func restart(){
        grid = Array(repeating: Array(repeating: nil, count: cols), count: rows)
        score = 0
        isGameOver = false
        spawnNewTetromino()
    }
    
    func spawnNewTetromino(){
        let type = TetrominoType.allCases.randomElement()!
        let tetromino = Tetromino(type: type, x: cols / 2-1, y: 0)
        
        if !isValid(tetromino){
            isGameOver = true
        }else{
            current = tetromino
        }
    }
    
    func moveLeft(){
        guard var tetromino = current else { return }
        tetromino.x -= 1
        if isValid(tetromino){
            current = tetromino
        }
    }
    
    func moveRight(){
        guard var tetromino = current else { return }
        tetromino.x += 1
        if isValid(tetromino){
            current = tetromino
        }
    }
    
    func rotate(){
        guard var tetromino = current else { return }
        tetromino.rotationIndex = (tetromino.rotationIndex + 1) % 4
        if isValid(tetromino){
            current = tetromino
        }
    }
    
    func moveDown(){
        guard var tetromino = current else { return }
        tetromino.y += 1
        if isValid(tetromino){
            current = tetromino
        }else{
            placeTetromino(current!)
            clearLines()
            spawnNewTetromino()
        }
    }
    
    /*func drop(){
        while let tetromino = current, isValid(tetromino) {
            moveDown()
        }
    }*/
    
    func isValid(_ tetromino: Tetromino) -> Bool{
        for (y, row) in tetromino.blocks.enumerated() {
            for(x, cell) in row.enumerated() {
                if cell == 0 {continue}
                let boardX = tetromino.x + x
                let boardY = tetromino.y + y
                if boardX < 0 || boardX >= cols || boardY < 0 || boardY >= rows {return false}
                if grid[boardY][boardX] != nil {return false}
            }
        }
        return true
    }
    
    func placeTetromino(_ tetromino: Tetromino){
        for (y, row) in tetromino.blocks.enumerated() {
            for(x, cell) in row.enumerated() {
                if cell == 1 {
                    let px = tetromino.x + x
                    let py = tetromino.y + y
                    if py >= 0 && py < rows && px >= 0 && px < cols {
                        grid[py][px] = tetromino.type.color
                    }
                }
            }
        }
    }
    
    func clearLines(){
        grid = grid.filter { row in
            row.contains(where: { $0 == nil})
        }
        
        let cleared = rows - grid.count
        score += cleared * 100
        
        for _ in 0..<cleared{
            grid.insert(Array(repeating: nil as Color?, count: cols), at: 0)
        }
    }
}
