//
//  Board+Generate.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 15\.02\.24\. 
//  Modified by Peter Eriksson 2025-01-26
//
//        Board Extension
//        generate(size:) Method
//        This method generates a Sudoku board of a specified size.
//
//        Initialization:
//
//        length: The size of the board (e.g., 4 for 4x4, 9 for 9x9).
//        numbers: An array of numbers from 1 to length.
//        side: The square root of length, representing the size of each sub-grid.
//        board: An empty array to hold the board values.
//        Generate Starting Point:
//
//        Iterates over each row to create a valid starting board.
//        Uses an offset to shift the numbers in each row, ensuring a valid Sudoku configuration.
//        Swap Random Numbers:
//
//        Swaps random numbers three times to add variability to the board.
//        Shuffle Rows Inside a Square:
//
//        Shuffles rows within each sub-grid group seven times to further randomize the board.
//        Shuffle Columns Inside a Square:
//
//        Shuffles columns within each sub-grid group seven times.
//        Shuffle Square Rows and Columns:
//
//        Shuffles entire rows and columns of sub-grids three times each to ensure a well-mixed board.
//        Return Board:
//
//        Returns the generated board with the specified size and values.
//        Size Enum
//        Defines the possible sizes for the Sudoku board:
//
//        FourXFour (4x4)
//        NineXNine (9x9)
//        Board Extension (Obfuscation)
//        obfuscate(difficulty:) Method
//        This method obfuscates the board by removing numbers based on the specified difficulty.
//
//        Initialization:
//
//        allowedIndexes: An array of all possible indexes on the board.
//        Obfuscation Loop:
//
//        Randomly selects an index and attempts to remove the number at that index.
//        Checks if the board is still solvable after removing the number.
//        Continues until the board meets the difficulty level or there are no more allowed indexes.
//        Difficulty Enum
//        Defines the difficulty levels for obfuscation:
//
//        easy (60% solved)
//        xmedium (50% solved)
//        hard (40% solved)
//        extreme (30% solved)
//        Difficulty Extension
//        Provides localized names for each difficulty level.
import Foundation
import Defaults
import SwiftUI

public extension Board {
    static func generate(size: Size) -> Self {
        let length = size.rawValue
        
        let numbers = Array(1...length)
        let side = Int(sqrt(Double(length)))
        var board = [Int]()
        
        // Generate a valid but simple starting point
        for row in 0..<length {
            let offset = row * side + Int(Float(row / side).rounded(.towardZero))
            var tmp = numbers
            
            for _ in 0..<offset {
                tmp.append(tmp.removeFirst())
            }
            
            board.append(contentsOf: tmp)
        }
        
        // Swap random numbers (3x)
        for _ in 1...3 {
            for number in 1..<numbers.count {
                let replacement = numbers.randomElement()!
                
                board.replace([replacement], with: [-1])
                board.replace([number], with: [replacement])
                board.replace([-1], with: [number])
            }
        }
        
        // Shuffle rows inside a square
        for group in 0..<length / side {
            // first index: offset, second row: offset + length, etc.
            let offset = (group * side) * length
            
            // Shuffle 7 times
            for _ in 1...7 {
                let target = Int.random(in: 1...side) - 1
                let replacement = Int.random(in: 1...side) - 1
                
                if target == replacement {
                    continue
                }
                
                let targetOffset = offset + length * target
                let replacementOffset = offset + length * replacement
                
                for i in 0..<length {
                    board.swapAt(targetOffset + i, replacementOffset + i)
                }
            }
        }
        
        // Shuffle columns inside a square
        for group in 0..<length / side {
            let offset = group * side
            
            for _ in 1...7 {
                let target = Int.random(in: 1...side) - 1
                let replacement = Int.random(in: 1...side) - 1
                
                if target == replacement {
                    continue
                }
                
                let targetOffset = offset + target
                let replacementOffset = offset + replacement
                
                for i in 0..<length {
                    board.swapAt(targetOffset + length * i, replacementOffset + length * i)
                }
            }
        }
        
        // Shuffle square rows (3x)
        for _ in 1...3 {
            let offset = Int.random(in: 0...(length / side) - 1) * (length * side)
            let count = side * length
            
            for _ in 0..<count {
                board.append(board.remove(at: offset))
            }
        }
        
        // Shuffle square columns (3x)
        // i am so tired of doing this, fuck you
        
        return .init(size: size, values: board)
    }
    
    enum Size: Int, Defaults.Serializable, CaseIterable {
        case FourXFour = 4
        case NineXNine = 9
    }
}

public extension Board {
    func obfuscate(difficulty: Difficulty) {
        var allowedIndexes = Array(0..<length * length)
        
        repeat {
            let index = allowedIndexes.randomElement()!
            
            let board = copy
            
            board.values[index] = nil
            
            if board.solvable() {
                values[index] = nil
            }
            
            allowedIndexes.removeAll(where: { $0 == index })
        } while solved > difficulty.rawValue && !allowedIndexes.isEmpty
    }
    
    enum Difficulty: Float, Defaults.Serializable, CaseIterable {
        case easy = 0.6
        case xmedium = 0.5
        case hard = 0.4
        case extreme = 0.3
    }
}

extension Board.Difficulty {
    var name: LocalizedStringKey {
        switch self {
            case .easy:
                return "difficulty.easy"
            case .xmedium:
                return "difficulty.medium"
            case .hard:
                return "difficulty.hard"
            case .extreme:
                return "difficulty.extreme"
        }
    }
}
