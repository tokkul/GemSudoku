//
//  Board+Valid.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 15\.02\.24\. 
//  Modified by Peter Eriksson 2025-01-26
//

import Foundation

//public extension Board {
//    var valid: Bool {
//        // Validate rows
//        for row in 0..<length {
//            let offset = row * length
//            var seen = [Int]()
//            
//            for value in values[offset..<offset + length] {
//                guard let value = value else { continue }
//                
//                if seen.contains(value) {
//                    return false
//                }
//                
//                seen.append(value)
//            }
//        }
//        
//        // Validate columns
//        for column in 0..<length {
//            var seen = [Int]()
//            
//            for i in 0..<length {
//                guard let value = values[column + i * length] else { continue }
//                
//                if seen.contains(value) {
//                    return false
//                }
//                
//                seen.append(value)
//            }
//        }
//        
//        // Validate squares
//        // i don't think this does work ¯\_(ツ)_/¯
//        for square in 0..<side {
//            let offset = square * side
//            var numbers = [Int]()
//            
//            for i in 0..<side {
//                let columnOffset = offset + i * length
//                numbers.append(contentsOf: values[columnOffset..<columnOffset + side].compactMap { $0 })
//            }
//            
//            var seen = [Int]()
//            for number in numbers {
//                if seen.contains(number) {
//                    return false
//                }
//                
//                seen.append(number)
//            }
//        }
//        
//        return true
//    }
//}

public extension Board {
    var valid: Bool {
        // Validate rows
        for row in 0..<length {
            if !validateLine(values: Array(values[row * length..<row * length + length])) {
                return false
            }
        }
        
        // Validate columns
        for column in 0..<length {
            var columnValues =  [Int?]()
            for i in 0..<length {
                columnValues.append(values[column + i * length])
            }
            if !validateLine(values: columnValues) {
                return false
            }
        }
        
        // Validate squares
        let side = Int(sqrt(Double(length)))
        for squareRow in 0..<side {
            for squareCol in 0..<side {
                var squareValues = [Int?]()
                for row in 0..<side {
                    for col in 0..<side {
                        let index = (squareRow * side + row) * length + (squareCol * side + col)
                        squareValues.append(values[index])
                    }
                }
                if !validateLine(values: squareValues) {
                    return false
                }
            }
        }
        
        return true
    }
    
    private func validateLine(values: [Int?]) -> Bool {
        var seen = Set<Int>()
        for value in values {
            guard let value = value else { continue }
            if !seen.insert(value).inserted {
                return false
            }
        }
        return true
    }
}
