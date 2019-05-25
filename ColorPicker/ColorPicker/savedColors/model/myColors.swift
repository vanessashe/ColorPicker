//
//  myColors.swift
//  ReadColor
//
//  Created by 佘上翎18637 on 2019/1/21.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit

class MyColor: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(hexCode, forKey: "hexCode")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(isFavorite, forKey: "isFavorite")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        hexCode = aDecoder.decodeObject(forKey: "hexCode") as! String
        date = aDecoder.decodeObject(forKey: "date") as! Date
        isFavorite = aDecoder.decodeBool(forKey: "isFavorite")
    }
    
    var name: String = ""
    var hexCode: String = ""
    var date: Date
    var isFavorite: Bool = false
    var color: UIColor {
        get {
            if let num = hexCode.utils.hexValue {
                return num.utils.asRGB
            }
            return UIColor.clear
        }
    }
    
    init(name: String, hexCode: String) {
        self.name = name
        self.hexCode = hexCode
        self.date = Date()
    }
}

