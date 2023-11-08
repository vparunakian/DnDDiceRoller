//
//  Material.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 07.11.2023.
//

import Foundation
import SceneKit

enum Material {
    static let tableMaterial = createMaterial(named: "Table")
    static let wallMaterial = createMaterial(named: "Wall")
    static let diceMaterial = createMaterial(named: "Dice")
    
    static func createMaterial(named: String) -> SCNMaterial {
        let material = SCNMaterial()
        if let diffuse = UIImage(named: named) {
            material.diffuse.contents = diffuse
        }
        if let roughness = UIImage(named: "\(named)Roughness") {
            material.roughness.contents = roughness
        }
        if let metalness = UIImage(named: "\(named)Metalness") {
            material.metalness.contents = metalness
        }
        if let ambientOc = UIImage(named: "\(named)AO") {
            material.ambientOcclusion.contents = ambientOc
        }
        if let normal = UIImage(named: "\(named)Normal") {
            material.normal.contents = normal
        }
        return material
    }
}
