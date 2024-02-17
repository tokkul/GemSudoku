//
//  Game.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 15.02.24.
//

import Foundation

@Observable
public class Game {
    public let board: Board
    
    public var started = Date()
    
    public var correct = 0
    public var mistakes = 0
    
    var didCountAttempt = false
    var eligibleForStatistics = true
    
    public required init(board: Board) {
        self.board = board
    }
}

public extension Game {
    static func create(size: Board.Size, difficulty: Board.Difficulty) -> Self {
        let board = Board.generate(size: size)
        board.obfuscate(difficulty: difficulty)
        
        return .init(board: board)
    }
}
