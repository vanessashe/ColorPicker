//
//  detailViewer.swift
//  ReadColor
//
//  Created by 佘上翎18637 on 2019/1/21.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit

class DetailViewer: UIView {

    var color: UIColor = UIColor.clear {
        didSet {
            innerView.backgroundColor = color
        }
        
    }
    private var innerView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.round(frame.width/2)
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.6
        self.backgroundColor = UIColor.clear
//        self.backgroundColor = UIColor(white: 0.6, alpha: 0.4)
        
        let sr = frame.width/2
        let innerCircle = UIView(frame: CGRect(x: 0, y: 0, width: sr, height: sr))
        innerCircle.center = CGPoint(x: frame.width/2, y: frame.width/2)
        innerCircle.layer.round(sr/2)
        innerCircle.layer.borderColor = UIColor.white.cgColor
        innerCircle.layer.borderWidth = 0.8
        
        self.addSubview(innerCircle)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
