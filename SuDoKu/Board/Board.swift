//
//  Board.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 15\.02\.24\. 
//  Modified by Peter Eriksson 2025-01-26
//

import Foundation

@Observable
public class Board {
    public let size: Size
    public var values: [Int?]
    
    public required init(size: Size, values: [Int?]) {
        self.size = size
        self.values = values
    }
}

public extension Board {
    var length: Int {
        size.rawValue
    }
    var side: Int {
        Int(sqrt(Double(length)))
    }
    
    var solved: Float {
        1 - values.reduce(0) { $1 == nil ? $0 + 1 : $0 } / Float(length * length)
    }
}

extension Board {
    var copy: Board {
        Board(size: size, values: values)
    }
}
