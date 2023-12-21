//
//  Material.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 07.11.2023.
//

import SceneKit

enum Material: String, CaseIterable, Identifiable {
    case metalGold = "Metal034"
    case metalMatte = "Metal046A"
    case metalRefl = "Metal012"
    case plastic = "Plastic008"
    case wood = "Wood049"

    var id: String { rawValue }

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
            return UIColor(red: 0.83, green: 0.686, blue: 0.216, alpha: 1.0)
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

    static func textureRepeat(for node: SCNNode?) {
        guard let material = node?.geometry?.material(named: "main") else {
            return
        }
        [material.diffuse, material.roughness, material.normal].forEach { material in
            material.wrapS = .repeat
            material.wrapT = .repeat
            material.contentsTransform = SCNMatrix4MakeScale(10, 10, 0)
        }
    }

    func apply(to node: SCNNode?) {
        guard let node, let material = node.geometry?.material(named: "main") else {
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
}
