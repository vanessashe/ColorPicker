//
//  ColorSets.swift
//  ReadColor
//
//  Created by 佘上翎18637 on 2019/1/22.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit

class ColorSet {
    static let shared = ColorSet()
    private let colorSetSavingKey = "colorSetSavingKey"
    private var myColors:[MyColor] = []
//    private var colorDict:[String:String] = [:]
    private init() {
        
        if let data = UserDefaults.standard.data(forKey: colorSetSavingKey), let colors = NSKeyedUnarchiver.unarchiveObject(with: data) as? [MyColor] {
            myColors = colors
        }
    }
    
    func getList() -> [MyColor] {
        return myColors
    }
    
    func replace(with newColor: MyColor, at: Int) {
 
        if at >= myColors.count {
            return
        }
        
        if myColors[at].hexCode == newColor.hexCode {
            myColors[at] = newColor
            save()
        }
        
    }
    
    func replace(with colors: [MyColor]) {
        myColors = colors
        save()
    }
    
    
    func add(color: UIColor, named: String) {
        
        if myColors.contains(where: { (c) -> Bool in
            c.hexCode == color.utils.hexValue
        }) {
           return
        }
        myColors.insert(MyColor(name: named, hexCode: color.utils.hexValue), at: 0)
       
        save()
        
    }
    
    func remove(color: MyColor) {
        
        myColors = myColors.filter({ (myColor) -> Bool in
            return myColor.color != color
        })
        save()
    }
    
    func remove(colors: [MyColor]) {
        myColors = myColors.filter({ (myColor) -> Bool in
            return !colors.contains(myColor)
        })
        save()
    }
    
    private func save() {
        let data = NSKeyedArchiver.archivedData(withRootObject: myColors)
        UserDefaults.standard.set(data, forKey: colorSetSavingKey)
        
    }
}

