//
//  NodeType.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 21.11.2023.
//

import Foundation

enum NodeType: String, Identifiable {
    case camera
    case d10
    case d12
    case d20
    case d4
    case d6
    case d8
    case table
    case unknown
    case wall

    static let allDice = [Self.d4, .d6, .d8, .d10, .d12, .d20]

    var id: String { UUID().uuidString }
}
