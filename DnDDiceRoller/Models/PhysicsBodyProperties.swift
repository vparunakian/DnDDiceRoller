//
//  PhysicsBodyProperties.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 08.12.2023.
//

import SceneKit
// swiftlint:disable type_contents_order
struct PhysicsBodyProperties {
    var allowsResting = false
    var angularDamping = 0.1
    var categoryBitMask = 1_024
    var collisionBitMask = 1_024
    var contactTestBitMask = 1_024
    var damping = 0.1
    var friction = 0.5
    var mass = 1.0
    var restitution = 0.5

    // TODO: make mass and all of other parameters dependant on material
    static var dice: Self {
        var properties = Self()
        properties.allowsResting = true
        properties.angularDamping = 0.05
        properties.damping = 0.1
        properties.friction = 1
        properties.mass = 1
        properties.restitution = 0.9
        properties.categoryBitMask = 1
        properties.collisionBitMask = 1 | 64
        properties.contactTestBitMask = 1 | 64
        return properties
    }

    func apply(to node: SCNNode?) {
        guard let node, let geometry = node.geometry else {
            return
        }
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: geometry))
        body.allowsResting = allowsResting
        body.angularDamping = angularDamping
        body.categoryBitMask = categoryBitMask
        body.collisionBitMask = collisionBitMask
        body.contactTestBitMask = contactTestBitMask
        body.damping = damping
        body.friction = friction
        body.mass = mass
        body.restitution = restitution
        node.physicsBody = body
    }
}
// swiftlint:enable type_contents_order
