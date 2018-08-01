//
//  CameraCapture.swift
//  ooomiji
//
//  Created by ominext on 7/30/18.
//  Copyright © 2018 ominext. All rights reserved.
//

import AVFoundation
import UIKit

class CameraCapture: NSObject {
    let captureSession = AVCaptureSession()
    
    var captureDevice: AVCaptureDevice?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var frontCamera: Bool = true
    
    var stillImageOutput: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
    
    
}

extension CameraCapture: AVCapturePhotoCaptureDelegate {
    func prepare(completionHandler: @escaping (Error?) -> Void) -> Void {
        captureSession.sessionPreset = .photo
        captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: AVCaptureDevice.Position.front)!
        
        var input : AVCaptureDeviceInput?
        
        do {
            input = try AVCaptureDeviceInput(device: captureDevice!)
        } catch {
            print(error.localizedDescription)
        }
        
        captureSession.addInput(input!)
        
        if captureDevice != nil {
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            captureSession.startRunning()
            stillImageOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
        }
    }
    
    func display(on cameraView: UIView) {
        cameraView.layer.addSublayer(previewLayer!)
        previewLayer?.frame = cameraView.layer.bounds
        previewLayer?.videoGravity = .resizeAspectFill
    }
    
    func capture(completionHandler: @escaping (UIImage) -> Void) -> Void {
        if let videoConnection = stillImageOutput.connection(with: AVMediaType.video) {
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (imageDataSampleBuffer, error) in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!)
                let image = UIImage(data: imageData!)
                print("--Imagetaked: \(String(describing: image))")
                completionHandler(image!)
            })
        }
    }
}


