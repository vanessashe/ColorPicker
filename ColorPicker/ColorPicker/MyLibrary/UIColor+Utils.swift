//
//  UIColor+Utils.swift
//  ReadColor
//
//  Created by 佘上翎18637 on 2019/1/21.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit

extension Utils where Base == UIColor {
    
    /// Use base as RGB color code and return its UIColor.
    
    var hexValue: String {
        get {
            
                var r:CGFloat = 0
                var g:CGFloat = 0
                var b:CGFloat = 0
                var a:CGFloat = 0
                
                base.getRed(&r, green: &g, blue: &b, alpha: &a)
                let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

                return String(format:"#%06x", rgb).uppercased()
        }
    }
    
    func hsbString() -> String {
        let hsb = base.utils.hsbValue()
        
        
        
        return "\((hsb.h * 360).utils.round(to: 0) ), \((hsb.s * 100).utils.round(to: 0)), \((hsb.b * 100).utils.round(to: 0))".replacingOccurrences(of: ".0", with: "")
    }
    
    func cmykString() -> String {
    
        guard let cmyk = base.utils.cmykValue() else {
            return ""
        }

        
        return "\(cmyk.c.rounded()), \(cmyk.m.utils.round(to: 0)), \(cmyk.y.rounded()), \(cmyk.k.rounded())".replacingOccurrences(of: ".0", with: "")
        
    }
    
    func rgbString() -> String {
    
        let rgb = base.utils.rgbValue()
        
        return "\((rgb.r * 255).rounded()), \((rgb.g * 255).rounded()), \((rgb.b * 255).rounded())".replacingOccurrences(of: ".0", with: "")
    }
    
    func rgbValue() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
    
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        base.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (r: red, g: green, b: blue, a: alpha)
        
    }
    
    func cmykValue() -> (c:CGFloat, m: CGFloat, y: CGFloat, k: CGFloat)? {
        let colorSpace = CGColorSpaceCreateDeviceCMYK()
        let intent = CGColorRenderingIntent.perceptual
        guard let cmykColor = base.cgColor.converted(to: colorSpace, intent: intent, options: nil) , let components = cmykColor.components else {
            return nil
        }
        
        let c: CGFloat = components[0] * 100
        let m: CGFloat = components[1] * 100
        let y: CGFloat = components[2] * 100
        let k: CGFloat = components[3] * 100
        return (c, m, y, k)
        
    }
    
    func hsbValue() -> (h: CGFloat, s: CGFloat, b: CGFloat, alpha: CGFloat) {
        
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        base.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return (h: hue, s: saturation,b: brightness, alpha: alpha)
    }
    
    func similarBrightness(to color: UIColor, by interval: CGFloat = 0.15) -> Bool {
        
        let std = color.utils.hsbValue()
        let hsb = base.utils.hsbValue()
        
        let tooClose = hsb.s < std.s + 0.15 && hsb.b > std.b - 0.15
        
        return tooClose
        
    }
    
    
    func adjust(by vector: (h:CGFloat, s: CGFloat, b: CGFloat)) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        base.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        let sat = min(max(saturation + vector.s/100,0),1)
        let bri = min(max(brightness + vector.b/100,0),1)
        
        let color = UIColor(hue: hue + vector.h/360, saturation: sat
            , brightness: bri, alpha: alpha)
        return color
    }
    
    func with(alpha: CGFloat) -> UIColor {
        let rgb = base.utils.rgbValue()
        let color = UIColor(red: rgb.r, green: rgb.g, blue: rgb.b, alpha: alpha)
        return color
    }
    
    
    
    
    enum BrightLevel: Int {
        case superLight = 0
        case light
        case mid
        case dark
        case superDark
    }
}

/// Extend Int with `utils` proxy.
extension UIColor: UtilsCompatible { }
