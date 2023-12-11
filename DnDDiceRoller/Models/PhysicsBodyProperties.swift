//
//  PhysicsBodyProperties.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 08.12.2023.
//

import SceneKit

struct PhysicsBodyProperties {
    var allowsResting = false
    var angularDamping =  0.1
    var categoryBitMask = 1024
    var collisionBitMask = 1024
    var contactTestBitMask = 1024
    var damping = 0.1
    var friction = 0.5
    var mass = 1.0
    var restitution = 0.5
   
    func apply(to node: SCNNode?) {
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape())
        body.allowsResting = allowsResting
        body.angularDamping = angularDamping
        body.categoryBitMask = categoryBitMask
        body.collisionBitMask = collisionBitMask
        body.contactTestBitMask = contactTestBitMask
        body.damping = damping
        body.friction = friction
        body.mass = mass
        body.restitution = restitution
        
        node?.physicsBody = body
    }

    // TODO: make mass and all of other parameters dependant on material
    static var dice: PhysicsBodyProperties {
        var properties = Self()
        properties.allowsResting = true
        properties.angularDamping = 0.05
        properties.damping = 0.1
        properties.friction = 1
        properties.mass = 3.4
        properties.restitution = 0.9
        
        properties.categoryBitMask = 1
        properties.collisionBitMask = 1 | 64
        properties.contactTestBitMask = 1 | 64
        return properties
    }
}
