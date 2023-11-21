//
//  Decal.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 15.11.2023.
//

import SceneKit 

enum Decal: String {
    case d4 = "SFPR_D4"
    case dN = "SFPR_DN"
    
    func apply(to node: SCNNode?) {
        guard let node = node else {
            return
        }
        guard let material = node.geometry?.material(named: "decal") else {
            return
        }
        
        if let color = UIImage(named: "\(rawValue)_color") {
            material.diffuse.contents = color
        }
        if let normalMap = UIImage(named: "\(rawValue)_normal") {
            material.normal.contents = normalMap
        }
    }
}
