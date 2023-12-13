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
    case metalGold = "Metal034"
    case metalMatte = "Metal046A"
    
    var displayName: String {
        switch self {
        case .plastic:
            return "Blue Plastic"
        case .wood:
            return "Wood"
        case .metalGold:
            return "Gold Reflective Metal"
        case .metalRefl:
            return "Reflective Metal"
        case .metalMatte:
            return "Matte Metal"
        }
    }
    
    var decalColor: UIColor {
        switch self {
        case .plastic:
            return UIColor(red: 212/255, green: 175/255, blue: 55/255, alpha: 1.0)
        case .wood:
            return .black
        case .metalGold:
            return .black
        case .metalRefl:
            return .black
        case .metalMatte:
            return .white
        }
    }
        
    func apply(to node: SCNNode?) {
        guard let node = node, let material = node.geometry?.material(named: "main") else {
            return
        }
        
        material.diffuse.contents = UIImage(named: "\(rawValue)_color")
        material.roughness.contents = UIImage(named: "\(rawValue)_roughness")
        material.normal.contents = UIImage(named: "\(rawValue)_normal")
        material.metalness.contents = UIImage(named: "\(rawValue)_metalness")
        
        guard let material = node.geometry?.material(named: "decal") else {
            return
        }
        
        material.multiply.contents = decalColor
    }
    
    static func textureRepeat(for node: SCNNode?) {
        guard let material = node?.geometry?.material(named: "main") else {
            return
        }
        [material.diffuse, material.roughness, material.normal].forEach {
            $0.wrapS = .repeat
            $0.wrapT = .repeat
            $0.contentsTransform = SCNMatrix4MakeScale(10, 10, 0)
        }
    }
}

extension Material: Identifiable {
    var id: String { rawValue }
}
