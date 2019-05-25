//
//  myControl.swift
//  ReadColor
//
//  Created by 佘上翎18637 on 2019/1/22.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit

class MyControl: UIControl {
    

    private var imgView: UIImageView? {
        get {
            return self.subviews.first as? UIImageView
        }
    }
    func enable(_ shouldEnable: Bool) {
        self.isUserInteractionEnabled = shouldEnable
        let color = shouldEnable ? UIColor.white : UIColor.gray
        setIcon(color: color)
    }
    
    private func setIcon(color: UIColor) {
        guard let imgView = self.imgView else {
            return
        }
        
        let img = imgView.image?.withRenderingMode(.alwaysTemplate)
        imgView.image = img
        imgView.tintColor = color
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        setIcon(color: UIColor.gray)
        let t = CATransform3DIdentity
        self.layer.transform = CATransform3DScale(t, 0.9, 0.9, 1)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        
        if self.isUserInteractionEnabled {
            setIcon(color: UIColor.white)
        }
        
        let t = CATransform3DIdentity
        self.layer.transform = CATransform3DScale(t, 1, 1, 1)
    
    }
}
