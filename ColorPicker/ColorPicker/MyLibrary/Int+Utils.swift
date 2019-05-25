//
//  Int+Utils.swift
//  ReadColor
//
//  Created by 佘上翎18637 on 2019/1/23.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit

extension Utils where Base == Int {
    
    /// Use base as RGB color code and return its UIColor.
    var asRGB: UIColor {
        get {
            let rgb = self.base
            let red = (rgb >> 16) & 0xFF
            let green = (rgb >> 8) & 0xFF
            let blue = rgb & 0xFF
            let uiColor = UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
            return uiColor
        }
    }
}

/// Extend Int with `utils` proxy.
extension Int: UtilsCompatible { }
