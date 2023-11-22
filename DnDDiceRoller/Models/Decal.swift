//
//  Decal.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 15.11.2023.
//

import SceneKit 

enum Decal: String, CaseIterable {
    case sfpr = "SFPR"
    
    var displayName: String {
        switch self {
        case .sfpr:
            return "SF Pro Rounded"
        }
    }
    
    func apply(to node: SCNNode?) {
        guard let node = node else {
            return
        }
        guard let material = node.geometry?.material(named: "decal") else {
            return
        }
        
        let suffix = node.name == DiceType.d4.rawValue ? "D4" : "DN"
        if let color = UIImage(named: "\(rawValue)_\(suffix)_color") {
            material.diffuse.contents = color
        }
        if let normalMap = UIImage(named: "\(rawValue)_\(suffix)_normal") {
            material.normal.contents = normalMap
        }
    }
}

extension Decal: Identifiable {
    var id: String { rawValue }
}
