//
//  Board+Animation.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 16.02.24.
//

import Foundation

extension Board {
    func determineAnimation(index: Int) -> GameView.GameAnimation {
        if solved >= 1 {
            return .none
        }
        
        let row = Int((Float(index) / Float(length)).rounded(.towardZero))
        let column = index % length
        let squareX = column / side
        let squareY = row / side
        
        var squareCount = 0
        
        // Square
        let squareOffset = squareX * side + squareY * side * length
        for j in 0..<side {
            for k in 0..<side {
                if values[squareOffset + j + k * length] != nil {
                    squareCount += 1
                }
            }
        }
        
        if squareCount == length {
            return .square(x: squareX, y: squareY)
        }
        
        var rowCount = 0
        var columnCount = 0
        
        for i in 0..<length {
            // Row
            if values[row * length + i] != nil {
                rowCount += 1
            }
            
            // Column
            if values[i * length + column] != nil {
                columnCount += 1
            }
        }
        
        if rowCount == length {
            return .row(row: row)
        } else if columnCount == length {
            return .column(column: column)
        }
        
        return .none
    }
}
