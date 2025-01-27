//
//  GameTest.swift
//  SuDoKuTests
//
//  Created by Rasmus Krämer on 15\.02\.24\. 
//  Modified by Peter Eriksson 2025-01-26
//

import XCTest
import SuDoKu
import Defaults

final class GameTest: XCTestCase {
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}

    func testValidInput() {
        let game = Game.init(board: .init(size: .FourXFour, values: [
            nil, 2, 3, 4,
            3, 4, 1, 2,
            2, 3, 4, 1,
            4, 1, 2, 3,
        ]))
        
        XCTAssert(game.input(number: 1, index: 0).success)
        XCTAssertEqual(game.board.solved, 1)
    }
    
    func testInvalidInput() {
        Defaults[.allowMistakes] = false
        
        let game = Game.init(board: .init(size: .FourXFour, values: [
            nil, 2, 3, 4,
            3, 4, 1, 2,
            2, 3, 4, 1,
            4, 1, 2, 3,
        ]))
        
        XCTAssertFalse(game.input(number: 2, index: 0).success)
        XCTAssertNotEqual(game.board.solved, 1)
    }
    
    func testInvalidAllowedInput() {
        Defaults[.allowMistakes] = true
        
        let game = Game.init(board: .init(size: .FourXFour, values: [
            nil, 2, 3, 4,
            3, 4, 1, 2,
            2, 3, 4, 1,
            4, 1, 2, 3,
        ]))
        
        XCTAssert(game.input(number: 2, index: 0).success)
        XCTAssertEqual(game.board.solved, 1)
    }
}
