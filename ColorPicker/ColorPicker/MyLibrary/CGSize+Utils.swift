//
//  CGSize+Utils.swift
//  ReadColor
//
//  Created by 佘上翎18637 on 2019/1/21.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit
extension Utils where Base == CGSize {

    var tan: CGFloat {
        get {
            return base.height/base.width
        }
    }
}

extension CGSize: UtilsCompatible { }
