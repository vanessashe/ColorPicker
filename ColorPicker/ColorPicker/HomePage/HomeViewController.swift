//
//  HomeViewController.swift
//  ReadColor
//
//  Created by 佘上翎18637 on 2019/1/21.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var colorConfirmButton: BounceScaleBtn!
    @IBOutlet weak var btnBG: UIView!
    @IBOutlet weak var hexCodeLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var viewSavedColorBtn: UIButton!
    @IBOutlet weak var imageOptionBtn: UIButton!
    @IBOutlet weak var cameraView: CameraPreviewView!
    @IBOutlet weak var toolBarBgView: UIView!
    @IBOutlet weak var optionBarBgView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var tools: [MyControl]!
    @IBOutlet weak var cursorView: UIView!
    
    var currentPixelBuffer:CVPixelBuffer?
    let swipeUp = UISwipeGestureRecognizer()
    let swipeDown = UISwipeGestureRecognizer()
    let captureController = CaptureController()
    var lastChosen: MyControl?
    let imagePicker = UIImagePickerController()
    let detailViewer = DetailViewer(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
    var colorSet = AppDelegate.colorSet
    var cvPixelAssistant = PixelBufferTool()
    
    enum MediaType {
        case camera
        case photo
        case frozen
    }
    var photoSnapshot:UIImage?

    private var mediaType: MediaType = .camera {
        didSet {
            
            if mediaType == .photo {
                resetScrollViewAndSwipes()
                photoSnapshot = photoView.layer.toImage()
            } else {
                photoSnapshot = nil
            }
            
            let cameraInUse = mediaType == .camera
            scrollView.backgroundColor = mediaType == .photo ? UIColor.black : UIColor.clear
            
            swipeUp.isEnabled = mediaType == .photo
            swipeDown.isEnabled = swipeUp.isEnabled
            
            if cameraInUse {
                captureController.startRunning()
                photoView.image = nil
            } else {
                captureController.stopRunning()
            }
            tools[0].enable(!cameraInUse)
            tools[1].enable(cameraInUse)
        }
    }
    lazy var colorSetVC = ColorSetsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
//        imagePicker.sourceType = .savedPhotosAlbum
        configUI()
        drawShadow(on: imageOptionBtn.layer)
        drawShadow(on: viewSavedColorBtn.layer)
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight * 1.5)
        
        tools[0].enable(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if mediaType == .camera {
            getCaptureSession()
        }
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.bottomView.layoutIfNeeded()
        }) { (fini) in
            self.toolBarBgView.layer.customRounded(corners: [.bottomLeft, .topLeft], radius: 8)
            self.optionBarBgView.layer.customRounded(corners: [.bottomRight, .topRight], radius: 8)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureController.stopRunning()
    }
    
    @objc func getCaptureSession() {
        captureController.setDelegate(self)
        captureController.getCaptureSession(mediaType: .video, onSuccess: { [weak self] (session) in
            
            guard let `self` = self else {
                return
            }
            DispatchQueue.main.async {
                self.captureController.configPreviewLayer(on: self.cameraView)
                self.captureController.startRunning()
            }
            
        }) { (error) in }
    }
    
    private func drawShadow(on layer: CALayer) {
        layer.shadowRadius = 5
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.darkGray.cgColor
    }

    private func config(swipe: UISwipeGestureRecognizer, direction: UISwipeGestureRecognizer.Direction) {
        swipe.direction = direction
        swipe.numberOfTouchesRequired = 1
        swipe.addTarget(self, action: #selector(handleSwipe(_:)))
        cursorView.addGestureRecognizer(swipe)
    }
    
    private func resetScrollViewAndSwipes() {
        scrollView.setContentOffset(CGPoint.zero, animated: false)
        swipeUp.isEnabled = true
        swipeDown.isEnabled = false
    }
    
    private func configUI() {
        
        cursorView.addSubview(detailViewer)
        config(swipe: swipeUp, direction: .up)
        config(swipe: swipeDown, direction: .down)
        resetScrollViewAndSwipes()
        detailViewer.center = CGPoint(x: screenWidth/2, y: cursorView.frame.height/2)
        btnBG.layer.round(btnBG.frame.height/2)
    colorConfirmButton.layer.round(colorConfirmButton.frame.height/2)
        hexCodeLabel.layer.round(6)
        
    }
    
    private func update(color: UIColor) {
        DispatchQueue.main.async {
            self.detailViewer.color = color
            self.colorConfirmButton.backgroundColor = color
            self.hexCodeLabel.text = color.utils.hexValue
        }
    }

    @objc func handleSwipe(_ swipe: UISwipeGestureRecognizer) {
        
        if mediaType != .photo {
            return
        }
        var d = screenHeight - cursorView.frame.height
        if swipe.direction == .down {
            d = 0
        }
        
        switch swipe.state {
        case .ended:
            scrollView.setContentOffset(CGPoint(x: 0, y: d), animated: true)
            swipeUp.isEnabled = d == 0
            swipeDown.isEnabled = d != 0
            
        default:
            break
        }
    }
    
    private func moveCursor(_ touches: Set<UITouch>) {
        
        guard let touch = touches.first else {
            return
        }

        let center = touch.location(in: cursorView)
        let location = touch.location(in: photoView)
        
        if center.y >= cursorView.frame.height || location.y >= photoView.frame.height {
            return
        }
        
        detailViewer.center = center
        if mediaType == .camera {
            return
        } else if mediaType == .frozen {
            
            if let pixelColor = currentPixelBuffer ,let color = cvPixelAssistant.getColor(at: detailViewer.center, from:pixelColor) {

                update(color: color)
            }
            
        } else if mediaType == .photo {
            if let color = photoSnapshot?.utils.pixelColor(at: location) {
                update(color: color)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveCursor(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveCursor(touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveCursor(touches)
    }
    
    
    @IBAction func saveColor(_ sender: BounceScaleBtn) {
        
        guard let color = sender.backgroundColor else {
            return
        }
        throwColorBall()
        colorSet.add(color: color, named: "")
    }
    
    @IBAction func viewMyColors(_ sender: UIButton) {
        
        guard colorSet.getList().count > 0 else {
            return
        }
        
        colorSetVC.modalPresentationStyle = .overFullScreen
        colorSetVC.myColors = colorSet.getList()
        self.present(colorSetVC, animated: true) {}
    }
    
    @IBAction func selectPicture(_ sender: UIButton) {
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func toolBarAction(_ sender: MyControl) {
        
        if sender.tag < 2 && sender.tag >= 0 {
            freeze(sender.tag == 1)
            sender.enable(false)
        }
    }
    
    private func throwColorBall() {
        guard let pie = colorConfirmButton.snapshotView(afterScreenUpdates: true) else {
            return
        }
        
        pie.frame = btnBG.frame
        pie.frame.origin = CGPoint(x: (bottomView.frame.width - pie.frame.width)/2, y: pie.frame.origin.y)
        bottomView.addSubview(pie)
        
        UIView.animate(withDuration: 0.4, animations: {
          
            let center = self.optionBarBgView.convert(self.viewSavedColorBtn.center, to: self.bottomView)
            pie.frame.origin = CGPoint(x: center.x - 2.5, y: center.y - 2.5)
            pie.frame.size = CGSize(width: 5, height: 5)
        }) { (fini) in
            pie.removeFromSuperview()
        }
    }
    
    private func freeze(_ shouldFreeze: Bool) {
        
        if shouldFreeze && mediaType != .photo {
            mediaType = .frozen
            
        } else {
            mediaType = .camera
        }
    }
}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let coverImageKey = info[UIImagePickerController.InfoKey.originalImage]
        
        if let image = coverImageKey as? UIImage {
            photoView.contentMode = .scaleAspectFit
            self.photoView.image = image
            self.mediaType = .photo
        }
        
        self.dismiss(animated: true) {}
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
        }
    }
}

extension HomeViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        let center = detailViewer.center
        currentPixelBuffer = pixelBuffer
        
        if let color = cvPixelAssistant.getColor(at: center, from: pixelBuffer) {
            self.update(color: color)
        }
    }
}

extension HomeViewController {
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if mediaType == .camera {
            captureController.startRunning()
        }
        super.dismiss(animated: flag, completion: completion)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        captureController.stopRunning()
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}
