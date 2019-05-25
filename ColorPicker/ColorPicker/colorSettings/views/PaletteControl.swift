//
//  PaletteControl.swift
//  ReadColor
//
//  Created by 佘上翎18637 on 2019/1/24.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit

class PaletteControl: UIView {

    var pages: Int = 5
    private var currentPageIndex = 2
    var currentPage: Int {
        get {
            return currentPageIndex
        }
    }
    
    var colorSets: [UIColor]? {
        didSet {
            
            guard let sets = colorSets else {
                return
            }
            for i in 0...controls.count - 1 {
                let color = sets[i]
                controls[i].backgroundColor = color
            }
            let dotBorderColor = sets[2].withAlphaComponent(0.8)
            self.dotView.layer.borderColor = dotBorderColor.cgColor
        }
    }
    private var dotView: UIView!
    private var controls: [UIView] = []    
    private var unitWidth: CGFloat {
        get {
            return self.frame.width/CGFloat(pages)
        }
    }
    
    weak var delegate: PaletteControlDelegate?

    override func layoutSubviews() {
        super.layoutSubviews()
        drawControls()
        self.dotView.center = controls[currentPageIndex].center
        self.bringSubviewToFront(dotView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        
        
        let r:CGFloat = 10
        dotView = UIView(frame: CGRect(x: 0, y: 0, width: r, height: r))
        dotView.backgroundColor = UIColor.white
        self.addSubview(dotView)
        dotView.layer.cornerRadius = r/2
        dotView.layer.masksToBounds = true
        
        dotView.layer.borderWidth = 3
        dotView.layer.borderColor = UIColor.white.cgColor
    }
    
    
    private func drawControls() {
        
        if controls.count > 0 {
            return
        }
        
        
        let width:CGFloat = self.frame.width/CGFloat(pages)
        
        for index in 0...pages - 1 {
            
            let i = CGFloat(index)
            let rect = CGRect(x: width * i, y: 0, width: width, height: self.frame.height)
            let control = UIView(frame: rect)
            control.tag = index

            self.addSubview(control)
            self.controls.append(control)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard let location = touches.first?.location(in: self) else {
            return
        }
        
        let index = Int(location.x/unitWidth)
        
        setCurrentpage(to: index)
        let color = colorSets![currentPage]
        delegate?.selected(color: color)
        
    }
    
    func setCurrentpage(to page: Int) {
        if page >= controls.count {
            return
        }
        currentPageIndex = page
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveLinear, animations: {
            self.dotView.center = self.controls[page].center
        
        })
    }
}
