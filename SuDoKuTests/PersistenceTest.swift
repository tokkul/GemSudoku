//
//  PersistenceTest.swift
//  SuDoKuTests
//
//  Created by Rasmus Krämer on 15.02.24.
//

import XCTest
import SuDoKu
import Defaults

final class PersistenceTest: XCTestCase {
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}

    func testAttemptCounter() {
        let currentCount = Defaults[.attempts]
        let game = Game.create(size: .NineXNine, difficulty: .easy)
        let _ = game.input(number: 1, index: 0)
        
        XCTAssertEqual(currentCount + 1, Defaults[.attempts])
    }
}
