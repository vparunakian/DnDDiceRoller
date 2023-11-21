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
}

extension DiceType: Identifiable {
    var id: String { UUID().uuidString }
}
