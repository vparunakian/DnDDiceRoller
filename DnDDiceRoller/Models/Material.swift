//
//  Material.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 07.11.2023.
//

import Foundation
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
        if let displacement = UIImage(named: "\(rawValue)_displacement") {
            if self == .wood {
//                material.displacement.contents = displacement
//                material.displacement.intensity = 1
            }
        }
        
        
        //material.specular.contents = UIColor(white: 0.8, alpha: 1.0)
        //material.shininess = 70
    }
}
