//
//  SCNNode+Extensions.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 22.11.2023.
//

import SceneKit

extension SCNNode {
    
    var nodeType: NodeType {
        guard let name = name, let nodeType = NodeType(rawValue: name) else {
            return .table
        }
        return nodeType
    }
}
