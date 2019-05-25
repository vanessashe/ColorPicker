//
//  ColorInfoTag.swift
//  ReadColor
//
//  Created by 佘上翎18637 on 2019/1/30.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit

class ColorInfoTagView: UIView {

    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var tagLabel: UILabel!
    @IBOutlet private weak var frontView: UIView!

    @IBOutlet weak var copiedView: UILabel!
    override func layoutSubviews() {
        super.layoutSubviews()
        frontView.layer.cornerRadius = 7
        frontView.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.2
        
    }
    
    func config(tag: String, with value: String) {
        
        tagLabel.text = tag
        valueLabel.text = value
    }

    
    @IBAction func copyValue(_ sender: UIButton) {
        if let tagText = tagLabel.text, let value = valueLabel.text {
        UIPasteboard.general.string = "\(tagText):  \(value)"
        }
    
        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveLinear, animations: {
            self.copiedView.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2, delay: 0.4, options: .curveLinear, animations: {
            self.copiedView.alpha = 0
        }, completion: nil)
    
    }
    
}
