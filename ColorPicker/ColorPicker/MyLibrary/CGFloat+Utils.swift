//
//  CGFloat+Utils.swift
//  ReadColor
//
//  Created by 佘上翎18637 on 2019/2/1.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit

extension Utils where Base == CGFloat {
    
    /// Use base as RGB color code and return its UIColor.
    func round(to index: Int) -> String {
    
        let count = CGFloat(pow(10.0, Double(index)))
        
        let float = CGFloat(Int(count * base))/count
        return "\(float)"
        
    }
    
    
}

/// Extend Int with `utils` proxy.
extension CGFloat: UtilsCompatible { }

