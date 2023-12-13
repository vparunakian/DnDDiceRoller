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
    
    @Published var material = Material.plastic
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
        scene.physicsWorld.gravity = SCNVector3(x: 0, y: -9.9, z: 0)
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
       
        let shape = SCNPhysicsShape(geometry: SCNPlane(width: 80, height: 80))
        let body = SCNPhysicsBody(type: .static, shape: shape)
        body.categoryBitMask = 64
        body.collisionBitMask = 1
        body.contactTestBitMask = 1
        table.physicsBody = body
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
                                        y: 3,
                                        z: presentation.position.z + 2)
            } else {
                moveVector = SCNVector3(x: presentation.position.x,
                                        y: 4,
                                        z: presentation.position.z)
            }
            let move = SCNAction.move(to: moveVector, duration: 0.33)
            camera?.runAction(move)
            camera?.constraints = [lookAtConstraint]
        }
        
        // TODO: save to history of dice throws
        let aaa = DiceAnglesToNumberHelper.convertAnglesToNumber(for: currentDice?.presentation)
        print(currentDice?.presentation.eulerAngles ?? SCNVector3Zero)
        print(aaa)
    }
    
    func spawnDice(type: NodeType) {
        removeDiceIfNeeded()
        guard let dice = diceSceneManager.getNode(type: type)?.clone() else {
            return
        }
        material.apply(to: dice)
        decal.apply(to: dice)
        currentDice = dice
        
        dice.position = SCNVector3(0, 4, 0)
        
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
        let rotatingPush = SCNVector3(x: .random(in: -1...1), y: 0,
                                      z: .random(in: -1...1))
        let atPoint = SCNVector3(x: 0.5, y: 0.5, z: 0.5)
        let linearPush = SCNVector3(x: .random(in: -1...1), y: -1.5,
                                    z: -10)
        
        dice.physicsBody?.applyForce(rotatingPush, at: atPoint, asImpulse: true)
        dice.physicsBody?.applyForce(linearPush, asImpulse: true)
    }
    
    
    private func setupCameraConstraints(for dice: SCNNode) {
        camera?.constraints?.removeAll()
        camera?.removeAllActions()
        camera?.position = SCNVector3(0, 4.5, 5)
        camera?.eulerAngles = SCNVector3(x: -0.34907, y: 0, z: 0)

        let distanceConstraint = SCNDistanceConstraint(target: dice)
        distanceConstraint.minimumDistance = 5
        distanceConstraint.maximumDistance = 10
        distanceConstraint.influenceFactor = 0.8
        
        let lookAtConstraint = SCNLookAtConstraint(target: dice)
        lookAtConstraint.isGimbalLockEnabled = true
        
        let accelerationConstraint = SCNAccelerationConstraint()
        accelerationConstraint.decelerationDistance = 0.5
        
        camera?.constraints = [lookAtConstraint, accelerationConstraint, distanceConstraint]
    }
    
}

extension MainViewModel: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        renderer.showsStatistics = true
        // renderer.debugOptions = [.showWireframe, .showBoundingBoxes]
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
