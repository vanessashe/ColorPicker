//
//  ColorInfoCell.swift
//  ReadColor
//
//  Created by 佘上翎18637 on 2019/1/22.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit

class ColorInfoCell: UICollectionViewCell {
    
    @IBOutlet private weak var colorStick: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var hexCodeLabel: UILabel!
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
    
    
    func configUI(with myColor: MyColor, shouldDelete: Bool) {
    

        colorStick.backgroundColor = myColor.color
        hexCodeLabel.text = myColor.hexCode
        nameLabel.text = myColor.name
        
        if myColor.name != "" {
            nameLabel.isHidden = false
        }
        
        likeMarkView.isHidden = !myColor.isFavorite
        deletingMark.isHidden = !shouldDelete
        adjustNameTextColor()
        
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
//        deletingMark.isHidden = true
        likeMarkView.layer.round(likeMarkView.frame.width/2)

    }
    
    func adjustNameTextColor() {
        
        let color = colorStick.backgroundColor
        if let hsb = color?.utils.hsbValue() {
            nameLabel.textColor = UIColor.black
            deletingMark.backgroundColor = 0x424242.utils.asRGB
            if (hsb.b < 0.6 && hsb.s > 0.55) || hsb.b < 0.5 || (hsb.b < 0.95 && hsb.s > 0.7) {
                nameLabel.textColor = UIColor.white
                deletingMark.backgroundColor = UIColor.lightGray
            }
        }
        
    }
    
}

