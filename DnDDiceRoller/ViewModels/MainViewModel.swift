//
//  MainViewModel.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 20.11.2023.
//

import Combine
import SceneKit

final class MainViewModel: NSObject, ObservableObject {
    private(set) var sceneManager = MainSceneManager(scene: .main)
    private let diceSceneManager = MainSceneManager(scene: .dice)

    private var activeDices = [SCNNode]()
    private(set) var mainScene: SCNScene?

    @Published var material = Material.metalMatte
    @Published var decal = Decal.sfpr

    private var subcriptions = Set<AnyCancellable>()
    private let isRestingSubject = PassthroughSubject<Bool, Never>()

    // TODO: should I move debug parameters somewhere else?
    @Published var isDebugMode = true
    private(set) var nodeStats = NodeStats()
    @Published private(set) var lastNumberDice = -1

    override init() {
        super.init()
        self.setupMainScene()
        self.setupCameraPanning()
    }

    private func setupMainScene() {
        let scene = sceneManager.scene
        scene.physicsWorld.contactDelegate = self
        scene.physicsWorld.gravity = SCNVector3(x: 0, y: -9.805, z: 0)
        mainScene = scene
    }

    private func setupCameraPanning() {
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

    private func removeDiceIfNeeded() {
        guard !activeDices.isEmpty else {
            return
        }
        activeDices.forEach { $0.removeFromParentNode() }
    }

    private func setupCameraFollowing(dice: SCNNode) {
        sceneManager.resetCamera()
        sceneManager.cameraFollow(node: dice)
    }

    private func panCameraToDice() {
        sceneManager.cameraPanAndOverlook(node: activeDices.first)

        // TODO: save to history of dice throws
        lastNumberDice = DiceAnglesToNumberConverter.convertAnglesToNumber(for: activeDices.first?.presentation)
        print(lastNumberDice)
    }

    func spawnDice(type: NodeType) {
        removeDiceIfNeeded()
        guard let dice = diceSceneManager.getNode(type: type)?.clone() else {
            return
        }
        material.apply(to: dice)
        decal.apply(to: dice)
        activeDices.append(dice)

        dice.position = SCNVector3(0, 4, 0)

        let rotateAction = SCNAction.repeatForever(
            SCNAction.rotate(
                by: -.pi,
                around: SCNVector3(x: 0, y: 1, z: 0),
                duration: TimeInterval(10)
            )
        )

        dice.runAction(rotateAction)
        mainScene?.rootNode.addChildNode(dice)
        setupCameraFollowing(dice: dice)
    }

    func throwDice() {
        guard let currentDice = activeDices.first else {
            return
        }

        currentDice.removeAllActions()
        setupCameraFollowing(dice: currentDice)

        PhysicsBodyProperties.dice.apply(to: currentDice)
        currentDice.eulerAngles = SCNVector3(
            x: .random(in: -.pi...(.pi)),
            y: .random(in: -.pi...(.pi)),
            z: .random(in: -.pi...(.pi))
        )
        let rotatingPush = SCNVector3(
            x: .random(in: -1...1),
            y: 0,
            z: .random(in: -1...1)
        )
        let atVector = SCNVector3(
            x: .random(in: -0.5...0.5),
            y: .random(in: -0.5...0.5),
            z: .random(in: -0.5...0.5)
        )
        let linearPush = SCNVector3(
            x: .random(in: -1...1),
            y: -1.5,
            z: -10
        )

        currentDice.physicsBody?.applyForce(rotatingPush, at: atVector, asImpulse: true)
        currentDice.physicsBody?.applyForce(linearPush, asImpulse: true)
    }
}

extension MainViewModel: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // renderer.showsStatistics = true
        // renderer.debugOptions = [.showWireframe, .showBoundingBoxes]
        DispatchQueue.main.async { [unowned self] in
            if let dice = activeDices.first?.presentation {
                nodeStats.dicePosition = dice.position.description
                nodeStats.diceEulerAngles = dice.eulerAngles.description
                nodeStats.diceRotation = dice.rotation.description
            }
            let camera = sceneManager.camera.presentation
            nodeStats.cameraPosition = camera.position.description
            nodeStats.cameraEulerAngles = camera.eulerAngles.description
            nodeStats.cameraRotation = camera.rotation.description
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        if let physicsBody = activeDices.first?.physicsBody {
            isRestingSubject.send(physicsBody.isResting)
        }
    }
}

extension MainViewModel: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
        // TODO: add haptic feedback on contact
    }
}
