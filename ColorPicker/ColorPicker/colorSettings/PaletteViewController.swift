//
//  PaletteViewController.swift
//  ReadColor
//
//  Created by 佘上翎18637 on 2019/1/23.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit
import GoogleMobileAds
class PaletteViewController: UIViewController {

    @IBOutlet weak var pageControl: PaletteControl!
    @IBOutlet weak var shadowBgView: UIView!
    @IBOutlet weak var colorInfoView: UIView!
    @IBOutlet var bgPhotoView: [UIImageView]!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var colorNameTextField: UITextField!
    weak var colorInfoCellDelegate: ColorInfoDelegate?
    private var bannerView: GADBannerView!
    let backgroundColor = #colorLiteral(red: 0.9842836261, green: 0.9842377305, blue: 0.9928161502, alpha: 1)
    var myColor: MyColor? {
        didSet {
            resetUIColor()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        drawColorInfoTagViews()
        pageControl.delegate = self
        
        colorNameTextField.delegate = self
        bannerView = Banner.shared.view
        bannerView.backgroundColor = UIColor.lightGray
        bannerView.adUnitID = "ca-app-pub-7222545677691808/3942328525"
        bannerView.rootViewController = self
        bannerView.delegate = self
        addBannerViewToView(bannerView)
        
        bannerView.isAutoloadEnabled = true

//        bannerView.load(GADRequest())
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpBasicUI()
        colorInfoView.subviews.forEach { (sub) in
            if let tv = sub.subviews.first {
                tv.frame.origin = CGPoint.zero
                tv.frame.size = sub.frame.size
            }
        }
        
    }

    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    func saveName() {
        colorInfoCellDelegate?.rewrite(name: colorNameTextField.text ?? "")
        colorNameTextField.resignFirstResponder()
    }
    
    @IBAction func markAsLiked(_ sender: UIButton) {
        sender.tag = (sender.tag + 1) % 2
        
        if let img = sender.imageView?.image {
            sender.setImage(img.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        let like = sender.tag == 1
        
        sender.backgroundColor = like ? #colorLiteral(red: 1, green: 0.9201563597, blue: 0.9476245046, alpha: 0.8966377618) : #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.7476480694)
        sender.tintColor = like ? 0xC95F6D.utils.asRGB : 0x606060.utils.asRGB
        colorInfoCellDelegate?.mark(liked: like)
    }
    
    
    @IBAction func editName(_ sender: UIButton) {
    
        colorNameTextField.becomeFirstResponder()
        
    }
    
    private func drawColorInfoTagViews() {
        
        let count = colorInfoView.subviews.count
        
        for i in 0...count - 1 {
            let tagView = colorInfoView.subviews[i]
            guard let tv = Bundle.main.loadNibNamed("ColorInfoTagView", owner: nil, options: nil)?.first as? ColorInfoTagView else {
                return
            }

            tagView.addSubview(tv)
        }
    }

    private func configColorInfo(with color: UIColor) {
        let count = colorInfoView.subviews.count
        for i in 0...count - 1 {
            let tagView = colorInfoView.subviews[i]
            guard let tv = tagView.subviews.first as? ColorInfoTagView else {
                break
            }

            switch tagView.tag {
            case 0:
                tv.config(tag: "HEX", with: color.utils.hexValue)
            case 1:
                tv.config(tag: "RGB", with: color.utils.rgbString())
            case 2:
                tv.config(tag: "HSB", with: color.utils.hsbString())
                
            case 3:
                tv.config(tag: "CMYK", with: color.utils.cmykString())
            default:
                break
            }
        }
    }
    
    
    private func setUpBasicUI() {
        pageControl.layer.cornerRadius = 8
        pageControl.layer.masksToBounds = true
        
        shadowBgView.layer.shadowColor = UIColor.darkGray.cgColor
        shadowBgView.layer.shadowOffset = CGSize(width: 1, height: 1)
        shadowBgView.layer.shadowRadius = 4
        shadowBgView.layer.shadowOpacity = 0.2
        likeBtn.layer.round(likeBtn.frame.width/2)
        editBtn.layer.round(editBtn.frame.width/2)
    }
    
    private func resetUIColor() {
        
        if let myColor = myColor {
            let color = myColor.color
            let mid = setIndex(by: color)
            let colorset = myColor.generateSimilarColors(midIndex: mid)
                        pageControl.colorSets = colorset
            selected(color: color)
            colorImg(at: 0, with: friend(of: colorset[3]))
            colorImg(at: 1, with: colorset[3])
            colorNameTextField.textColor = colorset[3]
            colorNameTextField.text = myColor.name
            likeBtn.tag = myColor.isFavorite ? 0 : 1
            markAsLiked(likeBtn)
        }
    }
    
    private func setIndex(by color: UIColor) -> Int {
        var midIndex = 2
        if color.utils.similarBrightness(to: backgroundColor, by: 0.8) {
            midIndex = 0
        } else if color.utils.similarBrightness(to: backgroundColor){
            midIndex = 1
            
        } else if color.utils.hsbValue().b < 0.18 {
            midIndex = 4
        } else if color.utils.hsbValue().b < 0.30 {
            midIndex = 3
        }
        pageControl.setCurrentpage(to: midIndex)
        return midIndex
    }
    
    
    private func colorImg(at: Int, with color: UIColor) {
        
        guard at < 2, let image = bgPhotoView[at].image else {
            return
        }
        
        bgPhotoView[at].image = image.withRenderingMode(.alwaysTemplate)
        bgPhotoView[at].tintColor = color

    }
    
    
    private func friend(of color: UIColor) -> UIColor {
        
        let friend = color.utils.adjust(by: (h: 27, s: -10, b: 3))
        
        return friend
    }

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        saveName()
    }
    
}

extension PaletteViewController: PaletteControlDelegate {
    
    func selected(color: UIColor) {
        configColorInfo(with: color)
    }
    
}
extension PaletteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveName()
        return true
    }
}

extension PaletteViewController: GADBannerViewDelegate {

    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("did receive Ad")
        
        
    }
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        
    }

    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }

    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")

    }

    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")

    }

    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }

}

