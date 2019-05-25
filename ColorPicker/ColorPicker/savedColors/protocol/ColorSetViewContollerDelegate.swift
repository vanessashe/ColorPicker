//
//  ColorSetViewContollerDelegate.swift
//  ReadColor
//
//  Created by shelin on 2019/2/6.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit

protocol ColorSetViewControllerDelegate: class {
    func setPalette(color: MyColor, colorInfoDelegate: ColorInfoDelegate?)
    
}
