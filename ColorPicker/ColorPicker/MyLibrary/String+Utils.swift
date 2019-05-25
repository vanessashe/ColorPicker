//
//  String+Utils.swift
//  ReadColor
//
//  Created by  on 2019/1/22.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import Foundation
extension Utils where Base == String {
    
    /// Use base as RGB color code and return its UIColor.
    
    var hexValue: Int? {
        get {
            let b = base.uppercased()
            let str = b.replacingOccurrences(of: "#", with: "")
            let i = Int(str, radix: 16)
            return i
            
        }
    }
    
    
}

/// Extend Int with `utils` proxy.
extension String: UtilsCompatible { }


