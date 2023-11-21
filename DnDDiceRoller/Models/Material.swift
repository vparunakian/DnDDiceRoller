//
//  Material.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 07.11.2023.
//

import SceneKit

enum Material: String {
    case plastic = "Plastic008"
    case wood = "Wood049"
    case metalMirror = "Metal012"
    case metalRough = "Metal046A"
        
    func apply(to node: SCNNode?) {
        guard let node = node else {
            return
        }
        
        guard let material = node.geometry?.material(named: "main") else {
            return
        }
        
        if let color = UIImage(named: "\(rawValue)_color") {
            material.diffuse.contents = color
        }
        if let roughness = UIImage(named: "\(rawValue)_roughness") {
            material.roughness.contents = roughness
        }
        if let normalMap = UIImage(named: "\(rawValue)_normal") {
            material.normal.contents = normalMap
        }
        if let metalness = UIImage(named: "\(rawValue)_metalness") {
            material.metalness.contents = metalness
        }
    }
}
