//
//  NodeTypeTests.swift
//  DnDDiceRollerTests
//
//  Created by Volodymyr Parunakian on 20.12.2023.
//

@testable import DnDDiceRoller
import SceneKit
import XCTest

final class NodeTypeTests: XCTestCase {
    private let node = SCNNode()

    func testNodeUnknown() {
        XCTAssertEqual(node.nodeType, .unknown)

        node.name = "ball"
        XCTAssertEqual(node.nodeType, .unknown)

        node.name = "floor"
        XCTAssertNotEqual(node.nodeType, .unknown)
    }

    func testNodeTypes() {
        node.name = "d4"
        XCTAssertEqual(node.nodeType, .d4)

        node.name = "d6"
        XCTAssertEqual(node.nodeType, .d6)

        node.name = "d8"
        XCTAssertEqual(node.nodeType, .d8)

        node.name = "d10"
        XCTAssertEqual(node.nodeType, .d10)

        node.name = "d12"
        XCTAssertEqual(node.nodeType, .d12)

        node.name = "d20"
        XCTAssertEqual(node.nodeType, .d20)

        node.name = "camera"
        XCTAssertEqual(node.nodeType, .camera)

        node.name = "wall"
        XCTAssertEqual(node.nodeType, .wall)
    }

    func testAllDice() {
        XCTAssertEqual(NodeType.allDice, [.d4, .d6, .d8, .d10, .d12, .d20])
    }
}
