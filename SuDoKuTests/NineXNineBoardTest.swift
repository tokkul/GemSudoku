//
//  NineXNineBoardTest.swift
//  SuDoKuTests
//
//  Created by Rasmus Krämer on 15\.02\.24\. 
//  Modified by Peter Eriksson 2025-01-26
//

import XCTest
import SuDoKu

final class NineXNineBoardTest: XCTestCase {
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}
    
    // MARK: Generation
    
    func test9x9BoardValidity() {
        for _ in 1...250 {
            let board = Board.generate(size: .NineXNine)
            XCTAssert(board.valid)
        }
    }
    
    func test9x9BoardGenerationSpeed() {
        measure {
            let _ = Board.generate(size: .NineXNine)
        }
    }
    
    // MARK: Validity
    
    func testInvalid9x9Row() {
        let board = Board(size: .NineXNine, values: .init(repeating: 1, count: 81))
        XCTAssertFalse(board.valid)
    }
    
    func testInvalid9x9Column() {
        let board = Board(size: .NineXNine, values: [
            1, 2, 3, 4, 5, 6, 7, 8, 9,
            1, 2, 3, 4, 5, 6, 7, 8, 9,
            1, 2, 3, 4, 5, 6, 7, 8, 9,
            1, 2, 3, 4, 5, 6, 7, 8, 9,
            1, 2, 3, 4, 5, 6, 7, 8, 9,
            1, 2, 3, 4, 5, 6, 7, 8, 9,
            1, 2, 3, 4, 5, 6, 7, 8, 9,
            1, 2, 3, 4, 5, 6, 7, 8, 9,
            1, 2, 3, 4, 5, 6, 7, 8, 9,
        ])
        
        XCTAssertFalse(board.valid)
    }
    
    func testInvalid9x9Square() {
        let board = Board(size: .NineXNine, values: [
            1, 2, 3, 4, 5, 6, 7, 8, 9,
            2, 3, 4, 5, 6, 7, 8, 9, 1,
            3, 4, 5, 6, 7, 8, 9, 1, 2,
            4, 5, 6, 7, 8, 9, 1, 2, 3,
            5, 6, 7, 8, 9, 1, 2, 3, 4,
            6, 7, 8, 9, 1, 2, 3, 4, 5,
            7, 8, 9, 1, 2, 3, 4, 5, 6,
            8, 9, 1, 2, 3, 4, 5, 6, 7,
            9, 1, 2, 3, 4, 5, 6, 7, 8,
        ])
        
        XCTAssertFalse(board.valid)
    }
    
    // MARK: Solving
    
    func test9x9Solvable() {
        measure {
            let board = Board(size: .NineXNine, values: [
                1, 2,   3, 4,   5, 6,   7, 8, 9,
                4, nil, 6, nil, 8, nil, 1, 2, 3,
                7, 8,   9, 1,   2, 3,   4, 5, 6,
                2, 3,   4, 5,   6, 7,   8, 9, 1,
                5, nil, 7, 8,   9, 1,   2, 3, 4,
                8, 9,   1, 2,   3, 4,   5, 6, 7,
                3, 4,   5, 6,   7, 8,   9, 1, 2,
                6, nil, 8, 9,   1, 2,   3, 4, 5,
                9, 1,   2, 3,   4, 5,   6, 7, 8,
            ])
            
            XCTAssert(board.solvable())
        }
    }
    
    func test9x9Impossible() {
        measure {
            let board = Board(size: .NineXNine, values: [
                1,   2, 3, 4, 5, 6, 7,   8, 9,
                nil, 5, 6, 7, 8, 9, 1,   2, 4,
                7,   8, 9, 1, 2, 3, nil, 5, 6,
                2,   3, 4, 5, 6, 7, 8,   9, 1,
                5,   6, 7, 8, 9, 1, 2,   3, nil,
                8,   9, 1, 2, 3, 4, 5,   6, 7,
                3,   4, 5, 6, 7, 8, 9,   1, 2,
                6,   7, 8, 9, 1, 2, 3,   4, 5,
                9,   1, 2, 3, 4, 5, 6,   7, 8,
            ])
            
            XCTAssertFalse(board.solvable())
        }
    }
    
    // MARK: Obfuscating
    
    func test9x9Obfuscate() {
        let board = Board.generate(size: .NineXNine)
        board.obfuscate(difficulty: .allCases.randomElement()!)
            
        XCTAssert(board.solvable())
    }
    
    /*
     The results here a re unpredictable
    func test9x9ObfuscateSpeed() {
            let board = Board.generate(size: 9)
            board.obfuscate(difficulty: .extreme)
    }
     */
    
    // MARK: Suggestions
    
    func test9x9Suggestions() {
        measure {
            let board = Board(size: .NineXNine, values: [
                1, 2,   3, 4,   5,   6,   7, 8, 9,
                4, nil, 6, nil, 8,   nil, 1, 2, 3,
                7, 8,   9, 1,   2,   3,   4, 5, 6,
                2, 3,   4, 5,   6,   7,   8, 9, 1,
                5, nil, 7, 8,   nil, 1,   2, 3, 4,
                8, 9,   1, 2,   3,   4,   5, 6, 7,
                3, 4,   5, 6,   7,   8,   9, 1, 2,
                6, nil, 8, 9,   1,   2,   3, 4, nil,
                9, 1,   2, 3,   4,   nil, 6, 7, nil,
            ])
            
            XCTAssertEqual(board.suggestions(index: 10, strength: .none), [])
            
            XCTAssertEqual(board.suggestions(index: 10, strength: .square), [5])
            XCTAssertEqual(board.suggestions(index: 40, strength: .square), [9])
            XCTAssertEqual(board.suggestions(index: 80, strength: .square), [5, 8])
            
            XCTAssertEqual(board.suggestions(index: 10, strength: .full), [5])
            XCTAssertEqual(board.suggestions(index: 40, strength: .full), [9])
            XCTAssertEqual(board.suggestions(index: 80, strength: .full), [5, 8])
        }
    }
}
