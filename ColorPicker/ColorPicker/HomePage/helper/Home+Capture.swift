//
//  Home+Capture.swift
//  ReadColor
//
//  Created by 佘上翎18637 on 2019/2/20.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit
import AVFoundation

class CaptureController: NSObject {
    
    let output = AVCaptureVideoDataOutput()
    let session = AVCaptureSession()
    var paused = false
    
    enum ScannerError: Error {
        case UnauthorizedMediaType(_ : AVMediaType)
        case NoCaptureDevice(for: AVMediaType)
        case AddDeviceInputFailed
        case AddOutputFailed
        case UnsupportedObjectType(_ :AVMetadataObject.ObjectType)
    }
    
    func setDelegate(_ delegate: AVCaptureVideoDataOutputSampleBufferDelegate) {
        output.setSampleBufferDelegate(delegate, queue: DispatchQueue.main)
    }
    
    func configPreviewLayer(on previewView: CameraPreviewView) {
        previewView.session = session
    }
    func startRunning() {
        
        session.startRunning()
    }
    
    func stopRunning() {

        session.stopRunning()
        
    }
    
    func getCaptureSession(mediaType: AVMediaType, onSuccess: @escaping ((AVCaptureSession)->Void), onError: @escaping (Error)->Void ) {
        
        
        let mediaType: AVMediaType = mediaType
        let status = AVCaptureDevice.authorizationStatus(for: mediaType)
        
        func configureSession() throws {
            let device = try self.getCaptureDevice(for: .video)
            let input = try AVCaptureDeviceInput(device: device)
            try self.addInput(input, onSession: session)
            try self.addOutput(self.output, onSession: session)
        }
        
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: mediaType) { (success) in
                
                if success {
                    do {
                        try configureSession()
                        onSuccess(self.session)
                    } catch {
                        onError(error)
                    }
                } else {
                    onError(ScannerError.UnauthorizedMediaType(mediaType))
                }
            }
        case .authorized:
            do {
                try configureSession()
                onSuccess(session)
            } catch {
                onError(error)
            }
            onSuccess(session)
        default:
            onError(ScannerError.UnauthorizedMediaType(mediaType))
        }
    }
    
    private func getCaptureDevice(for type: AVMediaType) throws -> AVCaptureDevice {
        guard let device = AVCaptureDevice.default(for: type) else {
            throw ScannerError.NoCaptureDevice(for: type)
        }
        return device
    }
    
    private func addInput(_ input: AVCaptureInput, onSession session: AVCaptureSession ) throws {
        if session.canAddInput(input) {
            session.addInput(input)
        } else {
            throw ScannerError.AddDeviceInputFailed
        }
    }
    
    private func addOutput(_ output: AVCaptureVideoDataOutput, onSession session: AVCaptureSession) throws {
        if session.canAddOutput(output) {
            
            session.addOutput(output)
            
        } else {
            throw ScannerError.AddOutputFailed
        }
    }
}
