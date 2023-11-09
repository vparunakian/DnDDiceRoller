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
    static let diceMaterial = [1, 2, 6, 5, 3, 4].map { createMaterial(named: "Dice", withText: "\($0)") }
    
    static func createMaterial(named: String, withText text: String? = nil) -> SCNMaterial {
        let material = SCNMaterial()
        if var diffuse = UIImage(named: named) {
            if let text = text {
                let image = UIImage.getImageFromString(text, color: .yellow,
                                                       font: .systemFont(ofSize: 10))
                diffuse = diffuse.mergeWith(topImage: image!)
            }
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
