//
//  UIView+Tool.swift
//  ReadColor
//
//  Created by 佘上翎18637 on 2019/1/29.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit

extension Project where Base: UIView {
    
    func addShawdow(radius: CGFloat = 8, opacity: Float = 0.1) {

        base.layer.shadowOpacity = opacity
        base.layer.shadowRadius = radius
        base.layer.shadowOffset = CGSize(width: 1, height: 1)
        base.layer.shadowColor = UIColor.darkGray.cgColor
    }
}

extension UIView: ProjectCompatible {}

