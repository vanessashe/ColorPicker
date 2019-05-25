//
//  UIButton+Tool.swift
//  ReadColor
//
//  Created by shelin on 2019/2/11.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit

class BounceScaleBtn:UIButton {
    let scale:CGFloat = 0.9
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        convert(to: scale)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        convert(to: 1)
        print("cancelled")
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        convert(to: 1)
        print("ended")
    }

    private func convert(to: CGFloat) {
        let t = CATransform3DIdentity
        
        self.layer.transform = CATransform3DScale(t, to, to, to)
    }
    
    
}
