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
        
        let table = mainSceneManager.getNode(type: .table)
        table?.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape())
        mainScene = scene
    }
    
    private func setupCamera() {
        camera = mainSceneManager.getCamera()
    }
    
    private func applyTextures(to scene: SCNScene?) {
        let table = mainSceneManager.getNode(type: .table)
        Material.wood.apply(to: table)
    }
    
    private func removeDiceIfNeeded() {
        guard currentDice != nil else {
            return
        }
        currentDice?.physicsBody?.clearAllForces()
        currentDice?.removeAllActions()
        currentDice?.removeFromParentNode()
        currentDice = nil
    }
    
    private func setupPhysics(dice: SCNNode?) {
        dice?.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape())
        // TODO: make mass and all of other parameters dependant on material
        dice?.physicsBody?.angularDamping = 0.1
        dice?.physicsBody?.restitution = 0.3
        dice?.physicsBody?.friction = 0.7
        dice?.physicsBody?.mass = 0.15
        dice?.rotation = SCNVector4(.random(in: 0...1), .random(in: 0...1), .random(in: 0...1),
                                    Double.pi * .random(in: 0.1...2))
    }
    
    func spawnDice(type: DiceType) {
        removeDiceIfNeeded()
        guard let dice = diceSceneManager.getNode(type: type.nodeType)?.clone() else {
            return
        }
        material.apply(to: dice)
        decal.apply(to: dice)
        currentDice = dice
        
        dice.position = SCNVector3(0, 7, 0)
        
        let rotateAction = SCNAction.repeatForever(
            SCNAction.rotate(by: -Double.pi * 2,
                             around: SCNVector3(x: 0, y: 1, z: 0),
                             duration: TimeInterval(10))
        )
      
        dice.runAction(rotateAction)
        mainScene?.rootNode.addChildNode(dice)
    }
    
    func throwDice() {
        currentDice?.removeAllActions()
        setupPhysics(dice: currentDice)
        
        let pushDirection = SCNVector3(x: .random(in: -0.4...(-0.1)), y: 0,
                                       z: .random(in: -0.4...(-0.1)))
        let atPoint = SCNVector3(x: .random(in: 0.1...2.0), y: .random(in: 0.1...2.0),
                                 z: .random(in: 0.1...2.0))
        currentDice?.physicsBody?.applyForce(pushDirection, at: atPoint, asImpulse: true)
        let torque = SCNVector4(.random(in: 0...0.3), .random(in: 0...0.3), .random(in: 0...0.3),
                                Double.pi * .random(in: 0.05...0.5))
        currentDice?.physicsBody?.applyTorque(torque, asImpulse: false)
    }
}
