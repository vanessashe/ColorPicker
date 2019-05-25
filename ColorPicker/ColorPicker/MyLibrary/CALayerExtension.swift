//
//  CALayerExtension.swift
//  EZDatingApp
//
//  Created by 佘上翎18637 on 2018/11/12.
//  Copyright © 2018年 佘上翎18637. All rights reserved.
//

import UIKit

extension CALayer {
    
    func toImage() -> (UIImage) {
        
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 1)
        //        UIGraphicsBeginImageContext(self.bounds.size)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.interpolationQuality = .high
            
            self.render(in: context)
        }
        let outputImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return outputImage
        
    }
    
    
    func customRounded(corners:UIRectCorner,radius:CGFloat) {
        
        let path = UIBezierPath(roundedRect:self.bounds,
                                byRoundingCorners:corners,
                                cornerRadii: CGSize(width: radius, height:  radius))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        self.mask = maskLayer
        self.masksToBounds = true
        
    }
    
    func round(_ r: CGFloat) {
        self.cornerRadius = r
        self.masksToBounds = true
    }
    
    
    func normalUCBCellShadow() {
        self.shadowColor = UIColor(white: 0.1, alpha: 1).cgColor
        self.shadowOpacity = 0.6
        self.shadowRadius = self.cornerRadius
        
        self.shadowOffset = CGSize(width: 0, height: 2)
    }
    
}
