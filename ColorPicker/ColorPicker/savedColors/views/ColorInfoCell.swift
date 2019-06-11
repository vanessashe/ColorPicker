//
//  ColorInfoCell.swift
//  ReadColor
//
//  Created by 佘上翎18637 on 2019/1/22.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit

class ColorInfoCell: UICollectionViewCell {
    
    @IBOutlet fileprivate weak var colorStick: UIView!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var hexCodeLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var deletingMark: UIView!
    @IBOutlet weak var likeMarkView: UIView!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        decorate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    func decorate() {

        bgView.subviews.first?.layer.cornerRadius = 8        
        let sLayer = bgView.layer
        sLayer.shadowOffset = CGSize(width: 1, height: 1)
        sLayer.shadowColor = UIColor(hue: 2/3, saturation: 0.01, brightness: 0.3, alpha: 1).cgColor
        sLayer.shadowRadius = 8
        sLayer.shadowOpacity = 0.3
        sLayer.masksToBounds = false

        deletingMark.layer.cornerRadius = deletingMark.frame.width/2
        deletingMark.layer.masksToBounds = true

    likeMarkView.layer.round(likeMarkView.frame.width/2)

    }
    
}

class ColorInfoViewModel {
    var myColor: MyColor
    
    init(color:MyColor) {
        self.myColor = color
    }
    
    func config(_ cell: ColorInfoCell,shouldDelete: Bool) {
        
        cell.colorStick.backgroundColor = myColor.color
        cell.hexCodeLabel.text = myColor.hexCode
        cell.nameLabel.text = myColor.name
        
        if myColor.name != "" {
            cell.nameLabel.isHidden = false
        }
        
        cell.likeMarkView.isHidden = !myColor.isFavorite
        cell.deletingMark.isHidden = !shouldDelete
        let hsb = myColor.color.utils.hsbValue()
        
        cell.nameLabel.textColor = UIColor.black
        cell.deletingMark.backgroundColor = 0x424242.utils.asRGB
        if (hsb.b < 0.6 && hsb.s > 0.55) || hsb.b < 0.5 || (hsb.b < 0.95 && hsb.s > 0.7) {
            cell.nameLabel.textColor = UIColor.white
            cell.deletingMark.backgroundColor = UIColor.lightGray
        }
        
    }
}

