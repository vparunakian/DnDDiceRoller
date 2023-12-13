//
//  DnDDiceRollerUITests.swift
//  DnDDiceRollerUITests
//
//  Created by Volodymyr Parunakian on 12.12.2023.
//

import DnDDiceRoller
import XCTest

final class DnDDiceRollerUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIDevice.shared.orientation = .portrait
        let app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
    
    func testDiceSpawnButtons() throws {
        let app = XCUIApplication()

        for dice in NodeType.allDice {
            app.buttons[dice.rawValue].tap()
        }
    }
}
