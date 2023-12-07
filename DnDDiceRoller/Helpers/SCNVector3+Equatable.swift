//
//  SCNVector3+Comparable.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 28.11.2023.
//

import SceneKit

extension SCNVector3 {
    var isZero: Bool {
        x.isZero && y.isZero && z.isZero
    }
}

extension SCNVector3: Equatable {
    public static func == (lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
}
