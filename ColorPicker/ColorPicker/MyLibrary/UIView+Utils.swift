//
//  UIView+Utils.swift
//  ReadColor
//
//  Created by 佘上翎18637 on 2019/1/23.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//
import UIKit
extension Utils where Base == UIView {
    
    func stick(to attribute: [NSLayoutConstraint.Attribute]) {
        
        guard let view = base.superview else {
            return
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        base.translatesAutoresizingMaskIntoConstraints = false
        
        
        for attr in attribute {
            let contraint = NSLayoutConstraint(item: base, attribute: attr, relatedBy: .equal, toItem: view, attribute: attr, multiplier: 1, constant: 0)
//            contraint.isActive = true
            base.addConstraint(contraint)
        }
    }
    
    
    
}

extension UIView: UtilsCompatible { }
