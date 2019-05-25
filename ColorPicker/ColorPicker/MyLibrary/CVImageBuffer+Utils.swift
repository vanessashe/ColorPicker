//
//  CIImage+Utils.swift
//  ReadColor
//
//  Created by 佘上翎18637 on 2019/1/23.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit

extension Utils where Base == CVImageBuffer {
    func createCGImage() -> CGImage? {
        
        let ciImage = CIImage(cvImageBuffer: base)
        let context = CIContext(options: [CIContextOption.useSoftwareRenderer : true])
        let rect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(base), height: CVPixelBufferGetHeight(base))
        let cgImage = context.createCGImage(ciImage, from: rect)
        
        return cgImage
    }
    

}
extension CVImageBuffer: UtilsCompatible {}
