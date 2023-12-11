//
//  NodeStats.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 08.12.2023.
//

import Combine

final class NodeStats: ObservableObject {
    @Published var dicePosition = ""
    @Published var diceEulerAngles = ""
    @Published var diceRotation = ""
    @Published var cameraPosition = ""
    @Published var cameraEulerAngles = ""
    @Published var cameraRotation = ""
}
