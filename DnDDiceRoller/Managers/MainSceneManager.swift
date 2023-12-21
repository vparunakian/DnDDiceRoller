//
//  MainSceneManager.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 21.11.2023.
//

import SceneKit

final class MainSceneManager {
    private enum DefaultCamera {
        static let position = SCNVector3(0, 4.5, 5)
        static let eulerAngels = SCNVector3(x: -0.1, y: 0, z: 0)
    }

    private static let assets = "SceneKitAssets.scnassets"
    private(set) var scene: SCNScene
    private(set) lazy var camera = setupDefaultCamera()

    init(scene: SceneType) {
        guard let scene = SCNScene(named: "\(Self.assets)/\(scene.rawValue)") else {
            fatalError("Scene is missing")
        }
        self.scene = scene
    }

    private func setupDefaultCamera() -> AccessibleNode {
        let camera = SCNCamera()
        camera.fieldOfView = 42
        let cameraNode = AccessibleNode()
        cameraNode.name = "camera"
        cameraNode.camera = camera
        cameraNode.position = DefaultCamera.position
        cameraNode.eulerAngles = DefaultCamera.eulerAngels
        cameraNode.accessibilityIdentifier = cameraNode.name
        scene.rootNode.addChildNode(cameraNode)
        return cameraNode
    }

    func getNode(type: NodeType) -> SCNNode? {
        scene.rootNode.childNode(withName: type.rawValue, recursively: false)
    }

    func resetCamera() {
        camera.constraints?.removeAll()
        camera.removeAllActions()
        camera.position = DefaultCamera.position
        camera.eulerAngles = DefaultCamera.eulerAngels
    }

    func cameraFollows(node: SCNNode?) {
        let distanceConstraint = SCNDistanceConstraint(target: node)
        distanceConstraint.minimumDistance = 5
        distanceConstraint.maximumDistance = 10
        distanceConstraint.influenceFactor = 0.8

        let lookAtConstraint = SCNLookAtConstraint(target: node)
        lookAtConstraint.isGimbalLockEnabled = true

        let accelerationConstraint = SCNAccelerationConstraint()
        accelerationConstraint.decelerationDistance = 0.5

        camera.constraints = [distanceConstraint, lookAtConstraint, accelerationConstraint]
    }

    func cameraPansAndOverlooks(node: SCNNode?) {
        guard let presentation = node?.presentation else {
            return
        }

        let lookAtConstraint = SCNLookAtConstraint(target: node)

        let moveVector: SCNVector3

        if presentation.nodeType == .d4 {
            moveVector = SCNVector3(
                x: presentation.position.x,
                y: 3,
                z: presentation.position.z + 2
            )
        } else {
            moveVector = SCNVector3(
                x: presentation.position.x,
                y: 4,
                z: presentation.position.z
            )
        }
        let move = SCNAction.move(to: moveVector, duration: 0.33)
        camera.runAction(move)
        camera.constraints = [lookAtConstraint]
    }
}
