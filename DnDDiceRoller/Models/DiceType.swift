//
//  DiceType.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 07.11.2023.
//

import Foundation

enum DiceType: String, CaseIterable {
    case d4
    case d6
    case d8
    case d10
    case d10t
    case d12
    case d20
    
    var nodeType: NodeType {
        switch self {
        case .d4:
            return .d4
        case .d6:
            return .d6
        case .d8:
            return .d8
        case .d10, .d10t:
            return .d10
        case .d12:
            return .d12
        case .d20:
            return .d20
        }
    }
}

extension DiceType: Identifiable {
    var id: String { UUID().uuidString }
}
