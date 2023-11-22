//
//  MainViewModel.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 20.11.2023.
//

import Combine
import SceneKit

final class MainViewModel: ObservableObject {  
    private let mainSceneManager = MainSceneManager(scene: .main)
    private let diceSceneManager = MainSceneManager(scene: .dice)
    
    private var currentDice: SCNNode?
    @Published private(set) var mainScene: SCNScene?
    @Published private(set) var camera: SCNNode?
    
    @Published var material = Material.metalRefl
    @Published var decal = Decal.sfpr
    
    init() {
        self.setupMainScene()
        self.setupCamera()
    }
    
    
    private func setupMainScene() {
        let scene = mainSceneManager.scene
        applyTextures(to: scene)
        mainScene = scene
    }
    
    private func setupCamera() {
        camera = mainSceneManager.getCamera()
    }
    
    private func applyTextures(to scene: SCNScene?) {
        let table = mainSceneManager.getNode(type: .table)
        Material.wood.apply(to: table)
    }
    
    func spawnDice(type: DiceType) {
        guard let dice = diceSceneManager.getNode(type: type.nodeType)?.clone() else {
            return
        }
        removeDice()
        material.apply(to: dice)
        decal.apply(to: dice)
        dice.position = SCNVector3(0, 5, 0)
        currentDice = dice
        
        let rotateAction = SCNAction.repeatForever(
            SCNAction.rotate(by: CGFloat(-Double.pi * 2), around: SCNVector3(x: 0, y: 1, z: 1),
                             duration: TimeInterval(10))
        )
      
        dice.runAction(rotateAction)
        mainScene?.rootNode.addChildNode(dice)
    }
    
    func removeDice() {
        currentDice?.removeFromParentNode()
        currentDice = nil
    }
}
