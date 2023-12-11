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
        case (-0.1...0.1, 1.9...1.91):  // X: -1.24963, Y: -0.84498, Z: -3.12754
            return 2
        case (0.95...0.96, -2.18...(-2.17)): // 2.47611, Y: -0.61734, Z: 1.60793  -1.90722, Y: 0.18326, Z: 0.97682
            return 3
        case (-0.96...(-0.95), -2.19...(-2.18)):
            return 4
        default:
            return -1
        }
    }
    
    private static func convertD6(_ dice: SCNNode) -> Int {
        switch (dice.eulerAngles.y, dice.eulerAngles.z) {
        case (-0.1...0.1, 1.55...1.58):
            return 1
        case (-0.1...0.1, -3.15...(-3.12)), (-0.1...0.1, 3.12...3.15):
            return 2
        case (-1.58...(-1.57), -0.1...0.1):
            return 3
        case (1.57...1.58, -0.1...0.1):
            return 4
        case (-0.1...0.1, -0.1...0.1):
            return 5
        case (-0.1...0.1, -1.58...(-1.55)):
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
        case (0.42...0.49, 0.8...0.83):
            return 1
        case (0.42...0.49, -2.35...(-2.3)):
            return 2
        case (-0.87...(-0.86), -0.37...(-0.36)):
            return 3
        case (-0.1...1.0, 2.2...2.36):
            return 4
        case (-0.1...1.0, -0.92...(-0.91)):
            return 5
        case (0.85...0.87, 2.7...2.78):
            return 6
        case (-0.5...(-0.43), 0.78...0.82):
            return 7
        case (-0.5...(-0.43), -2.35...(-2.3)):
            return 8
        case (0.85...0.87, -0.38...(-0.37)):
            return 9
        case (-0.87...(-0.86), 2.7...2.78):
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


