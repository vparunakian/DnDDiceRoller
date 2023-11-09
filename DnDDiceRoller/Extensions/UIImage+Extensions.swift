//
//  UIImage+Extensions.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 08.11.2023.
//

import UIKit

extension UIImage {
    static func getImageFromString(_ string: String,
                                   color: UIColor = .black,
                                   font: UIFont = .systemFont(ofSize: 14))
    -> UIImage? {
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.backgroundColor: UIColor.clear,
            NSAttributedString.Key.foregroundColor: color
        ]
        let textSize = string.size(withAttributes: attributes)

        UIGraphicsBeginImageContextWithOptions(textSize, false, UIScreen.main.scale)
        let rect = CGRect(origin: .zero, size: textSize)
        string.draw(in: rect, withAttributes: attributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func mergeWith(topImage: UIImage) -> UIImage {
        let bottomImage = self
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let areaSize = CGRect(x: 0, y: 0, width: bottomImage.size.width, height: bottomImage.size.height)
        bottomImage.draw(in: areaSize)
        
        let newX = (bottomImage.size.width / 2) - topImage.size.width / 2
        let newY = (bottomImage.size.height / 2) - topImage.size.height / 2

        let textRect = CGRect(x: newX, y: newY, width: topImage.size.width, height: topImage.size.height)
        let integral = CGRectIntegral(textRect)
        topImage.draw(in: integral, blendMode: .normal, alpha: 1)
        
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return mergedImage
    }
}
