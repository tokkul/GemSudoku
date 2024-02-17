//
//  Board+Clue.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 16.02.24.
//

import Foundation

public extension Board {
    /// Get a clue for this board. First value is the clue, second the index
    func clue() -> (Int, Int) {
        var availableIndexes = values.enumerated().filter { $0.element == nil }.map { $0.offset }.shuffled()
        
        while let index = availableIndexes.first {
            availableIndexes.removeFirst()
            
            for i in 1...length {
                let board = copy
                
                board.values[index] = i
                
                if board.valid && board.solvable() {
                    return (i, index)
                }
            }
        }
        
        return (0, 0)
    }
}
