//
//  Decal.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 15.11.2023.
//

import Foundation
import SceneKit 

enum Decal: String {
    case d4 = "SFPR_D4"
    case dN = "SFPR_DN"
    
    func apply(to node: SCNNode?) {
        guard let node = node else {
            return
        }
        node.geometry?.material(named: "decal")?.diffuse.contents = UIImage(named: rawValue)
    }
}
