//
//  UITextViewEXtension.swift
//  EZDatingApp
//
//  Created by 佘上翎18637 on 2018/11/29.
//  Copyright © 2018年 佘上翎18637. All rights reserved.
//

import UIKit

extension UITextView {
    func contentIsValid() -> Bool {
        let str = self.text
        var result = false
        
        for char in str! {
        
            if char != " " && char != "\n" {
                result = true
                break
            }
        }
        return result
    }
    
}
