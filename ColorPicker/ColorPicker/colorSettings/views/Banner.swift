//
//  Banner.swift
//  ColorPicker
//
//  Created by shelin on 2019/6/11.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import GoogleMobileAds
import UIKit

class Banner {
    static let shared = Banner()
    let view = GADBannerView(adSize: kGADAdSizeLargeBanner)
    private init() {
    }
    
}
