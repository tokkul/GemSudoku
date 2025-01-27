//
//  FourXFourBoardTest.swift
//  SuDoKuTests
//
//  Created by Rasmus Krämer on 15\.02\.24\. 
//  Modified by Peter Eriksson 2025-01-26
//

import XCTest
import SuDoKu

final class FourXFourBoardTest: XCTestCase {
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}
    
    // MARK: Generation
    
    func test4x4BoardValidity() {
        for _ in 1...250 {
            let board = Board.generate(size: .FourXFour)
            XCTAssert(board.valid)
        }
    }
    
    func test4x4BoardGenerationSpeed() {
        measure {
            let _ = Board.generate(size: .FourXFour)
        }
    }
    
    // MARK: Validity
    
    func testInvalid4x4Row() {
        let board = Board(size: .FourXFour, values: .init(repeating: 1, count: 16))
        XCTAssertFalse(board.valid)
    }
    
    func testInvalid4x4Column() {
        let board = Board(size: .FourXFour, values: [
            1, 2, 3, 4,
            1, 2, 3, 4,
            1, 2, 3, 4,
            1, 2, 3, 4,
        ])
        
        XCTAssertFalse(board.valid)
    }
    
    func testInvalid4x4Square() {
        let board = Board(size: .FourXFour, values: [
            1, 2, 3, 4,
            2, 3, 4, 1,
            3, 4, 1, 2,
            4, 1, 2, 3,
        ])
        
        XCTAssertFalse(board.valid)
    }
    
    // MARK: Solving
    
    func test4x4Solvable() {
        measure {
            let board = Board(size: .FourXFour, values: [
                1, nil, 3,   4,
                3, nil, 1,   2,
                2, 3  , nil, 1,
                4, nil, 2,   3,
            ])
            
            XCTAssert(board.solvable())
        }
    }
    
    // MARK: Obfuscating
    
    func test4x4Obfuscate() {
        for _ in 1...25 {
            let board = Board.generate(size: .FourXFour)
            board.obfuscate(difficulty: .allCases.randomElement()!)
            
            XCTAssert(board.solvable())
        }
    }
    
    func test4x4ObfuscateSpeed() {
        measure {
            let board = Board.generate(size: .FourXFour)
            board.obfuscate(difficulty: .extreme)
        }
    }
    
    // MARK: Suggestions
    
    func test4x4Suggestions() {
        measure {
            let board = Board.init(size: .FourXFour, values: [
                1,   nil, 2,   nil,
                nil, nil, 3,   nil,
                2,   3,   4,   1,
                nil, nil, nil, nil,
            ])
            
            XCTAssertEqual(board.suggestions(index: 1, strength: .none), [])
            
            XCTAssertEqual(board.suggestions(index: 1, strength: .square), [2, 3, 4])
            XCTAssertEqual(board.suggestions(index: 7, strength: .square), [1, 4])
            XCTAssertEqual(board.suggestions(index: 15, strength: .square), [2, 3])
            
            XCTAssertEqual(board.suggestions(index: 1, strength: .full), [4])
            XCTAssertEqual(board.suggestions(index: 7, strength: .full), [4])
            XCTAssertEqual(board.suggestions(index: 15, strength: .full), [2, 3])
        }
    }
}
