//
//  Board+Solve.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 15.02.24.
//

import Foundation

public extension Board {
    func solvable(index: Int = 0) -> Bool {
        if index == length * length {
            return true
        }
        
        if values[index] != nil {
            return solvable(index: index + 1)
        }
        
        for number in 1...length {
            let board = copy
            board.values[index] = number
            
            if !board.valid {
                continue
            }
            
            if board.solvable(index: index + 1) {
                return true
            }
        }
        
        return false
    }
}
