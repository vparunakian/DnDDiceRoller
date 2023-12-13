//
//  DiceRotationToNumberHelper.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 09.12.2023.
//

import SceneKit

enum DiceAnglesToNumberHelper {
    static func convertAnglesToNumber(for dice: SCNNode?) -> Int {
        guard let dice = dice else {
            return -1
        }
        switch dice.nodeType {
        case .d4:
            return convertD4(dice)
        case .d6:
            return convertD6(dice)
        case .d8:
            return convertD8(dice)
        case .d10:
            return convertD10(dice)
        case .d12:
            return convertD12(dice)
        default:
            return -1
        }
    }
    
    private static func convertD4(_ dice: SCNNode) -> Int {
        switch (dice.eulerAngles.y, dice.eulerAngles.z) {
        case (-0.1...0.1, -0.1...0.1):
            return 1
        case (-0.1...0.1, 1.9...1.99):
            return 2
        case (0.9...0.99, -2.2...(-2.1)):
            return 3
        case (-0.99...(-0.9), -2.2...(-2.1)):
            return 4
        default:
            return -1
        }
    }
    
    private static func convertD6(_ dice: SCNNode) -> Int {
        switch (dice.eulerAngles.y, dice.eulerAngles.z) {
        case (-0.1...0.1, 1.5...1.6):
            return 1
        case (-0.1...0.1, -3.15...(-3)), (-0.1...0.1, 3...3.15):
            return 2
        case (-1.6...(-1.5), -0.1...0.1):
            return 3
        case (1.5...1.6, -0.1...0.1):
            return 4
        case (-0.1...0.1, -0.1...0.1):
            return 5
        case (-0.1...0.1, -1.6...(-1.5)):
            return 6
        default:
            return -1
        }
    }
    
    private static func convertD8(_ dice: SCNNode) -> Int {
        switch (dice.eulerAngles.y, dice.eulerAngles.z) {
        case (0.6...0.62, 0.78...0.79):
            return 1
        case (0.6...0.62, -2.36...(-2.35)):
            return 2
        case (0.6...0.62, -0.79...(-0.78)):
            return 3
        case (0.6...0.62, 2.35...2.36):
            return 4
        case (-0.62...(-0.6), -0.79...(-0.78)):
            return 5
        case (-0.62...(-0.6), 2.35...2.36):
            return 6
        case (-0.62...(-0.6), 0.78...0.79):
            return 7
        case (-0.62...(-0.6), -2.36...(-2.35)):
            return 8
        default:
            return -1
        }
    }
    
    private static func convertD10(_ dice: SCNNode) -> Int {
        switch (dice.eulerAngles.y, dice.eulerAngles.z) {
        case (0.4...0.5, 0.8...0.85):
            return 1
        case (0.4...0.5, -2.35...(-2.3)):
            return 2
        case (-0.87...(-0.85), -0.38...(-0.34)):
            return 3
        case (-0.1...1.0, 2.2...2.36):
            return 4
        case (-0.1...1.0, -0.92...(-0.9)):
            return 5
        case (0.85...0.87, 2.7...2.8):
            return 6
        case (-0.5...(-0.43), 0.78...0.82):
            return 7
        case (-0.5...(-0.43), -2.35...(-2.3)):
            return 8
        case (0.85...0.87, -0.38...(-0.34)):
            return 9
        case (-0.87...(-0.85), 2.7...2.8):
            return 10
        default:
            return -1
        }
    }
    
    private static func convertD12(_ dice: SCNNode) -> Int {
        switch (dice.eulerAngles.y, dice.eulerAngles.z) {
        case (-0.1...1.0, -0.1...1.0):
            return 1
        case (0.42...0.49, -2.35...(-2.3)):
            return 2
        case (-0.23...(-0.22), -2.6...(-2.5)):
            return 3
        case (-0.1...1.0, 2.2...2.36):
            return 4
        case (-0.1...1.0, -0.92...(-0.91)):
            return 5
        case (0.85...0.87, 2.7...2.78):
            return 6
        case (-0.5...(-0.43), 0.78...0.82):
            return 7
        case (-0.16...(-0.15), 2.5...2.6):
            return 8
        case (-0.6...(-0.5), -0.1...1.0):
            return 9
        case (-0.87...(-0.86), 2.7...2.78):
            return 10
        case (-0.87...(-0.86), 2.7...2.78):
            return 11
        case (-0.87...(-0.86), 2.7...2.78):
            return 12
        default:
            return -1
        }
    }
}

//7 -2.48 0.52 1.4


//11 -0.44  0.05  -2.13

//12


