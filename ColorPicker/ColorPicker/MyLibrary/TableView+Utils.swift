//
//  TableViewExtension.swift
//  EZDatingApp
//
//  Created by 佘上翎18637 on 2018/11/9.
//  Copyright © 2018年 佘上翎18637. All rights reserved.
//

import UIKit
extension Utils where Base == UITableView {
    func registCell(with nibName: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        base.register(nib, forCellReuseIdentifier: nibName)
    }
    
    func registCells(with nibNames: [String]) {
        nibNames.forEach { (str) in
            base.utils.registCell(with: str)
        }
    }
}


extension Utils where Base == UICollectionView {
    
    func registCell(with nibName: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        base.register(nib, forCellWithReuseIdentifier: nibName)
    }
    
    func registCells(with nibNames: [String]) {
        
        nibNames.forEach { (str) in
            base.utils.registCell(with: str)
        }
    }
}
