//
//  ColorSetsViewController.swift
//  ReadColor
//
//  Created by 佘上翎18637 on 2019/1/22.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit

class ColorSetsViewController: UIViewController {
    
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    var myColors:[MyColor] = [] {
        didSet {
            collectionVC.myColors = myColors
        }
    }
    @IBOutlet weak var backBtn: MyControl!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var deleteToolBar: UIView!
    
    @IBOutlet weak var editBtn: UIButton!
    
    let paletteVC = PaletteViewController()
    let container = UIView()
    let container2 = UIView()
    let collectionVC = ColorCollectionViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        collectionVC.delegate = self
        topViewHeight.constant = screenHeight >= 812 ? 114 : 80
        placeContainersOnScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deleteToolBar.isHidden = true
        arrow.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        container.frame.size = scrollView.frame.size
        container2.frame.size = scrollView.frame.size
    }
    
    @IBAction func deleteSelectedItem(_ sender: UIButton) {
        collectionVC.delete()
        turnTo(deletion: false)
    }
    
    @IBAction func cancelDeletion(_ sender: UIButton) {
        turnTo(deletion: false)
        collectionVC.collectionView.reloadData()
    }
    
    
    private func placeContainersOnScrollView() {
        
        scrollView.contentSize = CGSize(width: screenWidth * 2, height: scrollView.frame.height)
        let itemFrame = CGRect(x: 0, y: 0, width: screenWidth, height: scrollView.frame.height)
        container.frame = itemFrame
        container2.frame = itemFrame
        container2.frame.origin.x = screenWidth
        scrollView.addSubview(container)
        scrollView.addSubview(container2)
        self.utils.addChildViewController(collectionVC, onView: container)
        self.utils.addChildViewController(paletteVC, onView: container2)
    }
    
    
    private func scroll(to page:Int) {
        let x = CGFloat(page) * screenWidth
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        animateArrow(to: page)
    paletteVC.colorNameTextField.resignFirstResponder()
        if page == 0 {
            paletteVC.saveName()
        }
        
        scrollView.isScrollEnabled = page == 1
    }
    
    
    @IBAction func edit(_ sender: UIButton) {
        
        turnTo(deletion: true)
    }
    
    @IBAction func dismiss(_ sender: MyControl) {
        if scrollView.contentOffset.x == 0 {
            
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        } else {
            scroll(to: 0)
        }
    }
    
    private func turnTo(deletion: Bool) {
        
        collectionVC.state = deletion ? .delete : .normal
        deleteToolBar.isHidden = !deletion
        editBtn.isHidden = deletion
        backBtn.isHidden = deletion
        collectionVC.preDelete(deletion)
        
        let anim = CASpringAnimation(keyPath: "transform.scale")
        anim.fromValue = 1.1
        anim.duration = 0.3
        anim.beginTime = CACurrentMediaTime()
        anim.damping = 0.8
        anim.fillMode = .forwards
        
        backBtn.layer.add(anim, forKey: "bounce")
        
    }
    private func delete(color: UIColor) {
        collectionVC.delete()
    }
    
    func animateArrow(to state: Int) {
        var angle: CGFloat = 0
        switch state {
        case 0:
            angle = 0
        case 1:
            angle = CGFloat(Double.pi/2)
        default:
            break
        }
        editBtn.isHidden = state == 1
        
        var t = CATransform3DIdentity
        t = CATransform3DRotate(t, angle, 0, 0, 1)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.arrow.layer.transform = t
        })
    }
}

extension ColorSetsViewController: UIScrollViewDelegate {
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 {
            scroll(to: 0)
        }
    }
}


extension ColorSetsViewController: ColorSetViewControllerDelegate {
    func setPalette(color: MyColor, colorInfoDelegate: ColorInfoDelegate?) {
        paletteVC.myColor = color
        paletteVC.colorInfoCellDelegate = colorInfoDelegate
        scroll(to: 1)
    }
    
}
