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
        self.setupWallNodes()
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

    private func setupWallNodes() {
        let wallN = AccessibleNode()
        wallN.geometry = SCNPlane(width: 120, height: 50)
        wallN.name = "wall"
        wallN.accessibilityIdentifier = wallN.name
        wallN.position = SCNVector3(x: 0, y: 25, z: -80)
        PhysicsBodyProperties.floor.apply(to: wallN)

        let material = SCNMaterial()
        material.name = "main"
        material.lightingModel = .physicallyBased
        material.metalness.contents = 0.5
        material.roughness.contents = 0.5
        material.diffuse.contents = UIColor.glacier
        wallN.geometry?.insertMaterial(material, at: 0)

        let wallS = wallN.clone()
        wallS.position = SCNVector3(x: 0, y: 25, z: 40)

        let wallE = wallN.clone()
        wallE.position = SCNVector3(x: 60, y: 25, z: -20)
        wallE.eulerAngles = SCNVector3(x: 0, y: -.pi / 2, z: 0)

        let wallW = wallE.clone()
        wallW.position = SCNVector3(x: -60, y: 25, z: -20)

        [wallN, wallS, wallE, wallW].forEach { wall in
            scene.rootNode.addChildNode(wall)
        }
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
