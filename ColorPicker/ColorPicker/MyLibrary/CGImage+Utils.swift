//
//  CGImage+Utils.swift
//  ReadColor
//
//  Created by 佘上翎18637 on 2019/1/23.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit

extension Utils where Base == CGImage {
    
    func getPixelColor(at point: CGPoint, scale: Int = 1) -> UIColor {
        
        
        guard let dataProvider = base.dataProvider,let pixelData = dataProvider.data else {
            return UIColor.black
        }
        
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let rowWidth = base.bytesPerRow
        
        let pixelInfo: Int = ((rowWidth/4 * Int(point.y) * scale) + Int(point.x) * scale) * 4
        
        let b = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let r = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        let color = UIColor(red: r, green: g, blue: b, alpha: a)
        
        return color
        
    }
    

    
}

extension CGImage: UtilsCompatible {}
