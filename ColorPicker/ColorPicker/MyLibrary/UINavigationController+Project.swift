//
//  UINavigationController+Project.swift
//  ReadColor
//
//  Created by 佘上翎18637 on 2019/1/23.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit

extension Project where Base : UINavigationController {
    
    func setStyle() {
        var size = base.navigationBar.frame.size
        size = CGSize(width: UIScreen.main.bounds.width, height: size.height + 20)
        base.navigationBar.tintColor = UIColor.darkGray
        base.navigationBar.barStyle = .default

    }
}

