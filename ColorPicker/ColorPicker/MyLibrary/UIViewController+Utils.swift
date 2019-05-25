//
//  UIViewController+Utils.swift
//  ReadColor
//
//  Created by 佘上翎18637 on 2019/1/23.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit

extension Utils where Base : UIViewController {
    
    /// Show loader to disable user interaction.
    
    
    func showLoader() {
        DispatchQueue.main.async {
            let vc = self.base
            var isLoaderBusy: Bool = false
            vc.children.forEach { (child) in
                if child is LoadingViewController {
                    isLoaderBusy = true
                    return
                }
            }
            guard !isLoaderBusy else { return }

            let loader = LoadingViewController()

            self.addChildViewController(loader, onView: vc.view)
        }
    }
    
    /// Hide loader to enable user interaction.
    func hideLoader() {
        DispatchQueue.main.async {
            let vc = self.base
            vc.children.forEach { (child) in
                if child is LoadingViewController {
                    child.view.removeFromSuperview()
                    child.removeFromParent()
                }
            }
        }
    }
    
    func showAlert(
        title: String?,
        message: String,
        confirmText: String,
        cancelText: String? = nil,
        onConfirm: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil,
        attributesForTitle: [NSAttributedString.Key : Any]? = nil,
        attributesForMessage: [NSAttributedString.Key : Any]? = nil) {
        
        //TODO: 這裡可能會需要將title跟message進行客製

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let attributesForTitle = attributesForTitle, let title = title {
            let attributedTitleText = NSMutableAttributedString(
                string: title,
                attributes: attributesForTitle
            )
            alertController.setValue(attributedTitleText, forKey: "attributedTitle")
        }
        
        if let attributesForMessage = attributesForMessage {
            let attributedMessageText = NSMutableAttributedString(
                string: message ,
                attributes: attributesForMessage
            )
            alertController.setValue(attributedMessageText, forKey: "attributedMessage")
        }
        
        if let onCancel = onCancel {
            let cancelAction = UIAlertAction(title: cancelText, style: .cancel) { (action) in
                onCancel()
            }

            alertController.addAction(cancelAction)
        }
        
        if let onConfirm = onConfirm {
            let confirmAction = UIAlertAction(title: confirmText, style: .default) { (action) in
                onConfirm()
            }
            alertController.addAction(confirmAction)
        }
        
        DispatchQueue.main.async {
            self.base.present(alertController, animated: true, completion: nil)
        }
    }
    /// Add childViewController and call didMove(toParentViewController: UIViewController)
    func addChildViewController(_ vc: UIViewController, onView: UIView) {
        if let newView = vc.view {
            base.addChild(vc)
            newView.translatesAutoresizingMaskIntoConstraints = true
            newView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            newView.frame = onView.bounds
            vc.willMove(toParent: base)
            onView.addSubview(newView)
            vc.didMove(toParent: base)
        }
    }
    
    /// Remove all childViewControllers
    func removeAllChildViewControllers() {
        if base.children.count > 0{
            let viewControllers:[UIViewController] = base.children
            for viewContoller in viewControllers {
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
    }
    
    
}

/// Extend Type inherited from UIViewController with `utils` proxy.
extension UIViewController: UtilsCompatible { }
