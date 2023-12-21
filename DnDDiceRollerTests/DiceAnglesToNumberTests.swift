//
//  DiceAnglesToNumberTests.swift
//  DnDDiceRollerTests
//
//  Created by Volodymyr Parunakian on 20.12.2023.
//

@testable import DnDDiceRoller
import SceneKit
import XCTest

final class DiceAnglesToNumberTests: XCTestCase {
    private var node: SCNNode?

    override func setUp() {
        node = SCNNode()
    }

    override func tearDown() {
        node = nil
    }

    private func convert(_ node: SCNNode?) -> Int {
        DiceAnglesToNumberConverter.convertAnglesToNumber(for: node)
    }

    func testNilNode() {
        node = nil
        XCTAssertEqual(convert(node), -1)
    }

    func testD4Conversions() {
        node = SCNNode()
        node?.name = "d4"

        node?.eulerAngles = SCNVector3(x: 0.5, y: 0.023, z: -0.033)
        XCTAssertEqual(convert(node), 1)

        node?.eulerAngles = SCNVector3(x: 1, y: 0.03, z: 1.92)
        XCTAssertEqual(convert(node), 2)

        node?.eulerAngles = SCNVector3(x: 10, y: 0.93, z: -2.15)
        XCTAssertEqual(convert(node), 3)

        node?.eulerAngles = SCNVector3(x: -10, y: -0.95, z: -2.2)
        XCTAssertEqual(convert(node), 4)
    }
}
