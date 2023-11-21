//
//  MainSceneManager.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 21.11.2023.
//

import SceneKit

final class MainSceneManager: SceneManager {
    private static let assets = "SceneKitAssets.scnassets"
    private(set) var scene: SCNScene
    
    init(scene: SceneType) {
        guard let scene = SCNScene(named: "\(Self.assets)/\(scene.rawValue)") else {
            fatalError("Scene is missing")
        }
        self.scene = scene
    }
    
    func getNode(type: NodeType) -> SCNNode? {
        scene.rootNode.childNode(withName: type.rawValue, recursively: false)
    }
    
    func getCamera() -> SCNNode? {
        getNode(type: .camera)
    }
}
