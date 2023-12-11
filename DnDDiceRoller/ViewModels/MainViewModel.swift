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
    private(set) var mainScene: SCNScene?
    var camera: SCNNode?
    
    @Published var material = Material.metalRefl
    @Published var decal = Decal.sfpr
    
    private var subcriptions = Set<AnyCancellable>()
    private let isRestingSubject = PassthroughSubject<Bool, Never>()

    // TODO: should I move debug parameters somewhere else?
    @Published var isDebugMode = true
    private(set) var nodeStats = NodeStats()
    
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
        
        isRestingSubject
            .share()
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .filter { $0 }
            .sink { [weak self] _ in
                self?.panCameraToDice()
            }
            .store(in: &subcriptions)
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
        currentDice?.removeFromParentNode()
        currentDice = nil
    }

    private func panCameraToDice() {
        let lookAtConstraint = SCNLookAtConstraint(target: currentDice)
        
        if let presentation = currentDice?.presentation {
            let moveVector: SCNVector3
            if presentation.nodeType == .d4 {
                moveVector = SCNVector3(x: presentation.position.x,
                                        y: 6,
                                        z: presentation.position.z + 6)
            } else {
                moveVector = SCNVector3(x: presentation.position.x,
                                        y: 12,
                                        z: presentation.position.z)
            }
            let move = SCNAction.move(to: moveVector, duration: 0.33)
            camera?.runAction(move)
            camera?.constraints = [lookAtConstraint]
        }
        
        // TODO: save to history of dice throws
        let _ = DiceAnglesToNumberHelper.convertAnglesToNumber(for: currentDice?.presentation)
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
            SCNAction.rotate(by: -.pi * 2,
                             around: SCNVector3(x: 0, y: 1, z: 0),
                             duration: TimeInterval(10))
        )
      
        dice.runAction(rotateAction)
        mainScene?.rootNode.addChildNode(dice)
        setupCameraConstraints(for: dice)
    }
    
    func throwDice() {
        guard let dice = currentDice else {
            return
        }

        dice.removeAllActions()
        setupCameraConstraints(for: dice)
        
        PhysicsBodyProperties.dice.apply(to: dice)
        dice.eulerAngles = SCNVector3(x: .random(in: -.pi...(.pi)), y: .random(in: -.pi...(.pi)),
                                      z: .random(in: -.pi...(.pi)))
        print(dice.presentation.eulerAngles)
        
        let rotatingPush = SCNVector3(x: .random(in: -0.2...0.2), y: 0,
                                       z: .random(in: -2...(-1)))
        let atPoint = SCNVector3(x: 0.1, y: 0.1, z: 0.1)
        let linearPush = SCNVector3(x: .random(in: -0.2...0.2), y: -3,
                                       z: -25)
        
        dice.physicsBody?.applyForce(rotatingPush, at: atPoint, asImpulse: true)
        dice.physicsBody?.applyForce(linearPush, asImpulse: true)
    }
    
    
    private func setupCameraConstraints(for dice: SCNNode) {
        camera?.constraints?.removeAll()
        camera?.removeAllActions()
        camera?.position = SCNVector3(0, 6, 14)
        camera?.eulerAngles = SCNVector3(x: -.pi/18, y: 0, z: 0)

        let distanceConstraint = SCNDistanceConstraint(target: dice)
        distanceConstraint.minimumDistance = 10
        distanceConstraint.maximumDistance = 20
        distanceConstraint.influenceFactor = 0.8
        
        let lookAtConstraint = SCNLookAtConstraint(target: dice)
        lookAtConstraint.isGimbalLockEnabled = true
        
        let accelerationConstraint = SCNAccelerationConstraint()
        accelerationConstraint.decelerationDistance = 3
        
        camera?.constraints = [lookAtConstraint, accelerationConstraint, distanceConstraint]
    }
    
}

extension MainViewModel: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async { [unowned self] in
            if let dice = currentDice?.presentation {
                nodeStats.dicePosition = dice.position.description
                nodeStats.diceEulerAngles = dice.eulerAngles.description
                nodeStats.diceRotation = dice.rotation.description
            }
            if let camera = camera?.presentation {
                nodeStats.cameraPosition = camera.position.description
                nodeStats.cameraEulerAngles = camera.eulerAngles.description
                nodeStats.cameraRotation = camera.rotation.description
            }
        }
    }
 
    func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        if let physicsBody = currentDice?.physicsBody {
            isRestingSubject.send(physicsBody.isResting)
        }
    }
}

extension MainViewModel: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
        // TODO: add haptic feedback on contact
    }
}
