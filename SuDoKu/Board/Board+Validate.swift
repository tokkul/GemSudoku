//
//  Board+Valid.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 15.02.24.
//

import Foundation

public extension Board {
    var valid: Bool {
        // Validate rows
        for row in 0..<length {
            let offset = row * length
            var seen = [Int]()
            
            for value in values[offset..<offset + length] {
                guard let value = value else { continue }
                
                if seen.contains(value) {
                    return false
                }
                
                seen.append(value)
            }
        }
        
        // Validate columns
        for column in 0..<length {
            var seen = [Int]()
            
            for i in 0..<length {
                guard let value = values[column + i * length] else { continue }
                
                if seen.contains(value) {
                    return false
                }
                
                seen.append(value)
            }
        }
        
        // Validate squares
        // i don't think this does work ¯\_(ツ)_/¯
        for square in 0..<side {
            let offset = square * side
            var numbers = [Int]()
            
            for i in 0..<side {
                let columnOffset = offset + i * length
                numbers.append(contentsOf: values[columnOffset..<columnOffset + side].compactMap { $0 })
            }
            
            var seen = [Int]()
            for number in numbers {
                if seen.contains(number) {
                    return false
                }
                
                seen.append(number)
            }
        }
        
        return true
    }
}
