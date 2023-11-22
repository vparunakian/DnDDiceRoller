//
//  Material.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 07.11.2023.
//

import SceneKit

enum Material: String, CaseIterable {
    case plastic = "Plastic008"
    case wood = "Wood049"
    case metalRefl = "Metal012"
    case metalMatte = "Metal046A"
    
    var displayName: String {
        switch self {
        case .plastic:
            return "Blue Plastic"
        case .wood:
            return "Wood"
        case .metalRefl:
            return "Reflective Metal"
        case .metalMatte:
            return "Matte Metal"
        }
    }
        
    func apply(to node: SCNNode?) {
        guard let node = node else {
            return
        }
        
        guard let material = node.geometry?.material(named: "main") else {
            return
        }
        
        material.diffuse.contents = UIImage(named: "\(rawValue)_color")
        material.roughness.contents = UIImage(named: "\(rawValue)_roughness")
        material.normal.contents = UIImage(named: "\(rawValue)_normal")
        material.metalness.contents = UIImage(named: "\(rawValue)_metalness")
    }
}

extension Material: Identifiable {
    var id: String { rawValue }
}
