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
        self.setupFloorNode()
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

    private func setupFloorNode() {
        let floor = AccessibleNode()
        floor.geometry = SCNPlane(width: 100, height: 100)
        floor.name = "floor"
        floor.accessibilityIdentifier = floor.name
        floor.position = SCNVector3(x: 0, y: 0, z: -35)
        floor.eulerAngles = SCNVector3(x: -.pi / 2, y: 0, z: 0)
        PhysicsBodyProperties.floor.apply(to: floor)

        let material = SCNMaterial()
        material.name = "main"
        material.lightingModel = .physicallyBased
        material.diffuse.contents = UIColor.blackWhite
        floor.geometry?.insertMaterial(material, at: 0)
        scene.rootNode.addChildNode(floor)
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

    func cameraFollow(node: SCNNode?) {
        let distanceConstraint = SCNDistanceConstraint(target: node)
        distanceConstraint.minimumDistance = 6
        distanceConstraint.maximumDistance = 12
        distanceConstraint.influenceFactor = 0.8

        let lookAtConstraint = SCNLookAtConstraint(target: node)
        lookAtConstraint.isGimbalLockEnabled = true
        lookAtConstraint.influenceFactor = 0.9

        let accelerationConstraint = SCNAccelerationConstraint()
        accelerationConstraint.decelerationDistance = 8

        camera.constraints = [distanceConstraint, lookAtConstraint, accelerationConstraint]
    }

    func cameraPanAndOverlook(node: SCNNode?) {
        guard let presentation = node?.presentation else {
            return
        }

        let lookAtConstraint = SCNLookAtConstraint(target: node)

        let moveVector: SCNVector3

        if presentation.nodeType == .d4 {
            moveVector = SCNVector3(
                x: presentation.position.x,
                y: 3.5,
                z: presentation.position.z + 2.5
            )
        } else {
            moveVector = SCNVector3(
                x: presentation.position.x,
                y: 4.5,
                z: presentation.position.z
            )
        }
        let move = SCNAction.move(to: moveVector, duration: 0.4)
        camera.runAction(move)
        camera.constraints = [lookAtConstraint]
    }
}
