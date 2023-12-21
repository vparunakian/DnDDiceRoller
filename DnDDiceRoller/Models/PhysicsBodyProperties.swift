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
    var angularDamping: CGFloat?
    var categoryBitMask = Int.max
    var collisionBitMask = Int.max
    var contactTestBitMask = Int.max
    var damping: CGFloat?
    var friction: CGFloat?
    var mass: CGFloat?
    var restitution: CGFloat?
    var bodyType = SCNPhysicsBodyType.dynamic

    func apply(to node: SCNNode?) {
        guard let node, let geometry = node.geometry else {
            return
        }
        let body = SCNPhysicsBody(type: bodyType, shape: SCNPhysicsShape(geometry: geometry))
        body.allowsResting = allowsResting
        body.categoryBitMask = categoryBitMask
        body.collisionBitMask = collisionBitMask
        body.contactTestBitMask = contactTestBitMask
        if let angularDamping { body.angularDamping = angularDamping }
        if let damping { body.damping = damping }
        if let friction { body.friction = friction }
        if let mass { body.mass = mass }
        if let restitution { body.restitution = restitution }
        node.physicsBody = body
    }

    // TODO: make mass and all of other parameters dependant on material
    static var dice: Self {
        var properties = Self()
        properties.allowsResting = true
        properties.angularDamping = 0.05
        properties.damping = 0.1
        properties.friction = 0.5
        properties.mass = 0.7
        properties.restitution = 0.9
        properties.categoryBitMask = 1
        properties.collisionBitMask = 1 | 64
        properties.contactTestBitMask = 1 | 64
        return properties
    }

    static var floor: Self {
        var properties = Self()
        properties.bodyType = .static
        properties.allowsResting = true
        properties.categoryBitMask = 64
        properties.collisionBitMask = 1
        properties.contactTestBitMask = 1
        return properties
    }
}
// swiftlint:enable type_contents_order
