//
//  MainViewModel.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 20.11.2023.
//

import Combine
import SceneKit

final class MainViewModel: NSObject, ObservableObject {
    private let mainSceneManager = MainSceneManager(scene: .main)
    private let diceSceneManager = MainSceneManager(scene: .dice)
    
    private var currentDice: SCNNode?
    var mainScene: SCNScene?
    var camera: SCNNode?
    
    @Published var material = Material.metalRefl
    @Published var decal = Decal.sfpr
    
    private var subcriptions = Set<AnyCancellable>()
    private let contactPublisher = PassthroughSubject<SCNVector3?, Never>()
    
    override init() {
        super.init()
        self.setupMainScene()
        self.setupCamera()
    }
    
    private func setupMainScene() {
        let scene = mainSceneManager.scene
        scene.physicsWorld.contactDelegate = self
        mainScene = scene
        setupTable()
    }
    
    private func setupCamera() {
        camera = mainSceneManager.getCamera()
    }
    
    private func setupTable() {
        let table = mainSceneManager.getNode(type: .table)!
        Material.wood.apply(to: table)
        Material.textureRepeat(for: table)
       
        let physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape())
        physicsBody.categoryBitMask = 64
        physicsBody.collisionBitMask = 1
        physicsBody.contactTestBitMask = 1
        table.physicsBody = physicsBody
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
        dice?.physicsBody?.restitution = 0.5
        dice?.physicsBody?.friction = 0.7
        dice?.physicsBody?.mass = 0.5
        dice?.physicsBody?.categoryBitMask = 1
        dice?.physicsBody?.collisionBitMask = 1 | 64
        dice?.physicsBody?.contactTestBitMask = 1 | 64
        dice?.rotation = SCNVector4(.random(in: 0...1), .random(in: 0...1), .random(in: 0...1),
                                    Double.pi * .random(in: 0.1...2))
    }
    
    private func setupCameraConstraints(for dice: SCNNode) {
        camera?.constraints?.removeAll()
        camera?.removeAllActions()
        camera?.position = SCNVector3(0, 8, 18)
        camera?.eulerAngles = SCNVector3(x: -0.17311926, y: 0, z: 0)

        let distanceConstraint = SCNDistanceConstraint(target: dice)
        distanceConstraint.minimumDistance = 10
        distanceConstraint.maximumDistance = 20
        distanceConstraint.influenceFactor = 0.5
        
        let lookAtConstraint = SCNLookAtConstraint(target: dice)
        lookAtConstraint.isGimbalLockEnabled = true
        // lookAtConstraint.influenceFactor = 0.8
        
        let accelerationConstraint = SCNAccelerationConstraint()
        accelerationConstraint.decelerationDistance = 3
        
        
        camera?.constraints = [lookAtConstraint, accelerationConstraint, distanceConstraint]
    }
    
    private func panCameraToDice() {
        camera?.removeAllActions()
        camera?.constraints?.removeAll()
        camera?.eulerAngles = SCNVector3(x: -0.17311926, y: 0, z: 0)
        
        let lookAtConstraint = SCNLookAtConstraint(target: currentDice)
        // lookAtConstraint.isGimbalLockEnabled = true
        
        if let currentDicePosition = currentDice?.presentation.position {
            let move = SCNAction.move(to: SCNVector3(x: currentDicePosition.x,
                                                     y: 10,
                                                     z: currentDicePosition.z),
                                      duration: 0.33)
            camera?.runAction(move)
        }
        camera?.constraints = [lookAtConstraint]
    }
    
    func spawnDice(type: NodeType) {
        removeDiceIfNeeded()
        guard let dice = diceSceneManager.getNode(type: type)?.clone() else {
            return
        }
        material.apply(to: dice)
        decal.apply(to: dice)
        currentDice = dice
        
        dice.position = SCNVector3(0, 5, 0)
        
        let rotateAction = SCNAction.repeatForever(
            SCNAction.rotate(by: -Double.pi * 2,
                             around: SCNVector3(x: 0, y: 1, z: 0),
                             duration: TimeInterval(10))
        )
      
        dice.runAction(rotateAction)
        mainScene?.rootNode.addChildNode(dice)
        setupCameraConstraints(for: dice)
    }
    
    func throwDice() {
        setupCameraConstraints(for: currentDice!)

        contactPublisher
            .share()
            .replaceNil(with: SCNVector3(x: 0, y: 0, z: 0))
            .filter { $0.isZero }
            .removeDuplicates()
            .sink { [weak self] contact in
                self?.panCameraToDice()
            }
            .store(in: &subcriptions)
        
        currentDice?.removeAllActions()
        setupPhysics(dice: currentDice)
        
        let pushDirection = SCNVector3(x: .random(in: -0.2...0.2), y: 0,
                                       z: .random(in: -3...(-1)))
        let atPoint = SCNVector3(x: .random(in: 0.1...2.0), y: .random(in: 0.1...2.0),
                                 z: .random(in: 0.1...2.0))
        let torque = SCNVector4(.random(in: 0...0.1), .random(in: 0...0.1), .random(in: 0...0.1),
                                .pi / 5)
        
        currentDice?.physicsBody?.applyForce(pushDirection, at: atPoint, asImpulse: true)
        currentDice?.physicsBody?.applyTorque(torque, asImpulse: true)
    }
}

extension MainViewModel: SCNPhysicsContactDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
        // detect when the node would stop
        contactPublisher.send(contact.nodeB.physicsBody?.velocity)
    }
}
