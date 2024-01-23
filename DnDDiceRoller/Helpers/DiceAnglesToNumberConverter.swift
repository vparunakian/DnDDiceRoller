//
//  DiceAnglesToNumberConverter.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 09.12.2023.
//

import SceneKit

// swiftlint:disable cyclomatic_complexity
enum DiceAnglesToNumberConverter {
    static func convertAnglesToNumber(for dice: SCNNode?) -> Int {
        guard let dice else {
            return -1
        }
        return switch dice.nodeType {
        case .d4:
            convertD4(dice)
        case .d6:
            convertD6(dice)
        case .d8:
            convertD8(dice)
        case .d10:
            convertD10(dice)
        case .d12:
            convertD12(dice)
        case .d20:
            convertD20(dice)
        default:
            -1
        }
    }

    private static func convertD4(_ dice: SCNNode) -> Int {
        switch (dice.eulerAngles.y, dice.eulerAngles.z) {
        case (-0.05...0.05, -0.1...0.1):
            1
        case (-0.05...0.05, 1.9...2.0):
            2
        case (0.9...1.0, -2.2...(-2.1)):
            3
        case (-1.0...(-0.9), -2.2...(-2.1)):
            4
        default:
            -1
        }
    }

    private static func convertD6(_ dice: SCNNode) -> Int {
        switch (dice.eulerAngles.y, dice.eulerAngles.z) {
        case (-0.1...0.1, 1.5...1.6):
            1
        case (-0.1...0.1, -3.15...(-3)), (-0.1...0.1, 3...3.15):
            2
        case (-1.6...(-1.5), -0.1...0.1):
            3
        case (1.5...1.6, -0.1...0.1):
            4
        case (-0.1...0.1, -0.1...0.1):
            5
        case (-0.1...0.1, -1.6...(-1.5)):
            6
        default:
            -1
        }
    }

    private static func convertD8(_ dice: SCNNode) -> Int {
        switch (dice.eulerAngles.y, dice.eulerAngles.z) {
        case (0.6...0.62, 0.75...0.8):
            1
        case (0.6...0.62, -2.36...(-2.35)):
            2
        case (0.6...0.62, -0.8...(-0.75)):
            3
        case (0.6...0.62, 2.35...2.36):
            4
        case (-0.62...(-0.6), -0.8...(-0.75)):
            5
        case (-0.62...(-0.6), 2.35...2.36):
            6
        case (-0.62...(-0.6), 0.75...0.8):
            7
        case (-0.62...(-0.6), -2.36...(-2.35)):
            8
        default:
            -1
        }
    }

    private static func convertD10(_ dice: SCNNode) -> Int {
        switch (dice.eulerAngles.y, dice.eulerAngles.z) {
        case (0.4...0.5, 0.8...0.9):
            1
        case (0.4...0.5, -2.35...(-2.3)):
            2
        case (-0.9...(-0.8), -0.38...(-0.34)):
            3
        case (-0.1...1.0, 2.2...2.36):
            4
        case (-0.1...1.0, -0.92...(-0.9)):
            5
        case (0.8...0.9, 2.7...2.8):
            6
        case (-0.5...(-0.43), 0.78...0.82):
            7
        case (-0.5...(-0.43), -2.35...(-2.3)):
            8
        case (0.8...0.9, -0.38...(-0.34)):
            9
        case (-0.9...(-0.8), 2.7...2.8):
            10
        default:
            -1
        }
    }

    private static func convertD12(_ dice: SCNNode) -> Int {
        switch (dice.eulerAngles.y, dice.eulerAngles.z) {
        case (-0.1...0.1, -0.1...1.0):
            1
        case (0.9...1.1, -0.6...(-0.5)):
            2
        case (-0.6...(-0.5), -2.15...(-2)):
            3
        case (-0.1...0.1, -1.12...(-0.11)):
            4
        case (-0.6...(-0.5), 0.9...1.1):
            5
        case (-1.1...(-1), -0.6...(-0.5)):
            6
        case (0.9...1.1, 2.5...2.6):
            7
        case (0.5...0.6, -2.15...(-2)):
            8
        case (-0.1...0.1, 2...2.1):
            9
        case (0.5...0.6, 0.9...1.1):
            10
        case (-1.1...(-0.9), 2.6...2.7):
            11
        case (-0.1...0.1, 3...3.5):
            12
        default:
            -1
        }
    }

    private static func convertD20(_ dice: SCNNode) -> Int {
        switch (dice.eulerAngles.y, dice.eulerAngles.z) {
        case (-0.1...0.1, -0.1...0.1):
            1
        case (-0.61...(-0.6), -2.73...(-2.72)):
            2
        case (0.34...0.35, 1.2...1.21):
            3
        case (0.36...0.37, -1.92...(-1.91)):
            4
        case (-0.64...(-0.63), -1.16...(-1.15)):
            5
        case (1.2...1.21, 2.71...2.73):
            6
        case (-0.62...(-0.61), 0.41...0.43):
            7
        case (-0.1...0.1, 2.4...2.42):
            8
        case (1.19...1.2, -0.42...(-0.41)):
            9
        case (-0.61...(-0.6), 1.98...1.99):
            10
        case (0.6...0.61, -1.16...(-1.15)):
            11
        case (-1.2...(-1.19), 2.71...2.73):
            12
        case (-0.1...0.1, -0.8...(-0.7)):
            13
        case (0.61...0.62, -2.73...(-2.72)):
            14
        case (-1.21...(-0.19), -0.43...(-0.41)):
            15
        case (0.63...0.64, 1.98...1.99):
            16
        case (-0.37...(-0.36), 1.22...1.23):
            17
        case (-0.35...(-0.33), -1.94...(-1.93)):
            18
        case (0.6...0.61, 0.42...0.43):
            19
        case (-0.1...0.1, -3.14...(-3.13)):
            20
        default:
            -1
        }
    }
}
// swiftlint:enable cyclomatic_complexity
