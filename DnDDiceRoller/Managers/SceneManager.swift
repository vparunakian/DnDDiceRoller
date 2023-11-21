//
//  SceneManager.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 20.11.2023.
//

import SceneKit

protocol SceneManager {
    init(scene: SceneType)
    func getCamera() -> SCNNode?
    func getNode(type: NodeType) -> SCNNode?
}
