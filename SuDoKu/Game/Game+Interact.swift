//
//  Game+Interact.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 16.02.24.
//

import Foundation
import Defaults
import SwiftUI

public extension Game {
    func input(number: Int, index: Int) -> InputResult {
        if !didCountAttempt {
            didCountAttempt = true
            Defaults[.attempts] += 1
        }
        
        let copy = board.copy
        copy.values[index] = number
        
        let valid = copy.valid && copy.solvable()
        
        if valid {
            correct += 1
            
            if eligibleForStatistics {
                Defaults[.correct] += 1
            }
        } else {
            mistakes += 1
            
            if eligibleForStatistics {
                Defaults[.mistakes] += 1
            }
        }
        
        if valid || Defaults[.allowMistakes] {
            board.values[index] = number
            return .init(success: true, animation: board.determineAnimation(index: index))
        }
        
        return .init(success: false, animation: .none)
    }
    
    struct InputResult {
        public let success: Bool
        let animation: GameView.GameAnimation
    }
}

public extension Game {
    func clue() -> (Int, Int) {
        Defaults[.clues] += 1
        eligibleForStatistics = false
        
        return board.clue()
    }
}
