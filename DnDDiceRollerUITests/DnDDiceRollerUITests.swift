//
//  DnDDiceRollerUITests.swift
//  DnDDiceRollerUITests
//
//  Created by Volodymyr Parunakian on 12.12.2023.
//

import XCTest

final class DnDDiceRollerUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIDevice.shared.orientation = .portrait
        let app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        let app = XCUIApplication()
        app.terminate()
    }

//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }

    func testButtons() throws {
        let app = XCUIApplication()

        ["d4", "d6", "d8", "d10", "d12", "d20"].forEach { buttonID in
            let button = app.buttons[buttonID]
            XCTAssertTrue(button.waitForExistence(timeout: 0.1))
            button.tap()
        }

        let scene = app.otherElements["MainScene"]
        scene.tap()

//        let screenshot = app.screenshot()
//        let attachment = XCTAttachment(screenshot: screenshot)
//        attachment.name = "Oops"
//        attachment.lifetime = .keepAlways
//        add(attachment)
    }

//    func textD6Throw() throws {
//        let app = XCUIApplication()
//        
//        app.buttons["d6"].tap()
//        
//        let element = app.staticTexts["diceNumber"]
//        XCTAssertTrue(element.waitForExistence(timeout: 0.5))
//        XCTAssertNotEqual(element.label, "-1")
//    }
}
