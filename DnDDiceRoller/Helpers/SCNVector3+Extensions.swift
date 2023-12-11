//
//  SCNVector3+Comparable.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 28.11.2023.
//

import SceneKit

//extension SCNVector3: Equatable {
//    public static func == (lhs: SCNVector3, rhs: SCNVector3) -> Bool {
//        lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
//    }
//}

extension SCNVector3: CustomStringConvertible {
    public var description: String {
        "X: \(x.roundToDecimal(5)), Y: \(y.roundToDecimal(5)), Z: \(z.roundToDecimal(5))"
    }
}

extension SCNVector4: CustomStringConvertible {
    public var description: String {
        """
            X: \(x.roundToDecimal(5)), Y: \(y.roundToDecimal(5)), Z: \(z.roundToDecimal(5)),
            W: \(w.roundToDecimal(5))
        """
    }
}
