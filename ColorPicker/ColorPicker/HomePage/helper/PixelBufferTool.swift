//
//  PixelBufferTool.swift
//  ReadColor
//
//  Created by shelin on 2019/3/28.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit

class PixelBufferTool {
    let fixedPhotoRatio:CGFloat = 9.0/16.0
    func getColor(at point: CGPoint ,from pixelBuffer: CVPixelBuffer) -> UIColor? {
        
        CVPixelBufferLockBaseAddress(pixelBuffer, [])
        let lumaBaseAddress = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0)
        let chromaBaseAddress = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1)
        
        guard let lumaBuffer = lumaBaseAddress?.assumingMemoryBound(to: UInt8.self), let chromaBuffer = chromaBaseAddress?.assumingMemoryBound(to: UInt8.self) else {
            return nil
        }
        
        let rgbIndice = computeRGBIndex(at: point, pixelBuffer: pixelBuffer)
        let lumaIndex = rgbIndice.luma
        let chromaIndex = rgbIndice.chroma
        if lumaIndex < 0 || chromaIndex < 0 {
            return nil
        }
        
        let yp = lumaBuffer[lumaIndex]
        let cb = chromaBuffer[chromaIndex]
        let cr = chromaBuffer[chromaIndex+1]
        let color = generateRGB(yp: yp, cb: cb, cr: cr)
        
        return color
    }
    
    
    private func computeRGBIndex(at point: CGPoint, pixelBuffer: CVPixelBuffer) -> (luma: Int, chroma: Int) {
        
        let width = CVPixelBufferGetWidth(pixelBuffer)
        
        let lumaBytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 0)
        let chromaBytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 1)
        
        let p = CGPoint(x: point.y, y: screenWidth - point.x)
        let scale:CGFloat = CGFloat(width)/screenHeight
        let x = Int(p.x * scale)
        let yOffset:CGFloat = (screenHeight * fixedPhotoRatio - screenWidth)/2
        
        let y = Int((p.y + yOffset) * scale)
        let lumaIndex = x+y*lumaBytesPerRow
        let chromaIndex = (y/2)*chromaBytesPerRow+(x/2)*2
        CVPixelBufferUnlockBaseAddress(pixelBuffer, [])
        return (luma: lumaIndex, chroma: chromaIndex)
    }
    
    private func generateRGB(yp: UInt8, cb: UInt8, cr: UInt8) -> UIColor {
        let ri = Double(yp) + 1.402 * (Double(cr) - 128)
        let gi = Double(yp) - 0.34414 * (Double(cb) - 128) - 0.71414 * (Double(cr) - 128)
        let bi = Double(yp) + 1.772 * (Double(cb) - 128)
        
        let r = CGFloat(min(max(ri,0), 255))
        let g = CGFloat(min(max(gi,0), 255))
        let b = CGFloat(min(max(bi,0), 255))
        
        let color = UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
        return color
    }
}
