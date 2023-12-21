//
//  SCNVector3+Comparable.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 28.11.2023.
//

import SceneKit

private let kDecimal = 5

extension SCNVector3: CustomStringConvertible {
    public var description: String {
        "X: \(x.roundToDecimal(kDecimal)), Y: \(y.roundToDecimal(kDecimal)), Z: \(z.roundToDecimal(kDecimal))"
    }
}

extension SCNVector4: CustomStringConvertible {
    public var description: String {
        """
            X: \(x.roundToDecimal(kDecimal)), Y: \(y.roundToDecimal(kDecimal)), Z: \(z.roundToDecimal(kDecimal)),
            W: \(w.roundToDecimal(kDecimal))
        """
    }
}
