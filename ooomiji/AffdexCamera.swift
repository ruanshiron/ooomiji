//
//  AffdexCamera.swift
//  ooomiji
//
//  Created by ominext on 8/1/18.
//  Copyright © 2018 ominext. All rights reserved.
//

import Foundation
import Affdex
import UIKit
import AVKit

class AffdexCamera: AFDXDetectorDelegate {
    
    var CameraView: UIImageView?
    
    var detector: AFDXDetector?
    
    // \Affdex Pr
    func detector(_ detector: AFDXDetector!, hasResults faces: NSMutableDictionary!, for image: UIImage!, atTime time: TimeInterval) {
        if (faces == nil) {
            self.unprocessedImageReady(detector, image: image, atTime: time)
        } else {
            
        }
    }
    

    
    init() {
        createDetector()
    }
}

extension AffdexCamera {
    func destroyDetector() {
        let error = self.detector?.stop()
        print(error?.localizedDescription ?? "\(self): NO STOP Error")
    }
    
    func createDetector() {
        let cameraCapture = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: AVCaptureDevice.Position.front)!
        
        self.detector = AFDXDetector(delegate: self, using: cameraCapture, maximumFaces: 1, face: FaceDetectorMode.init(0))
        
        self.detector?.setDetectAllEmotions(true)
        self.detector?.maxProcessRate = 2
        // START after
    }
    
    func startDetector() {
        if ((detector) != nil) {
            let error = self.detector?.start()
            print(error?.localizedDescription ?? "\(self): NO START Error")
        }
    }
}

extension AffdexCamera {
    func unprocessedImageReady(_ detector: AFDXDetector?, image: UIImage?, atTime time: TimeInterval) {
        DispatchQueue.main.async {
            var flippedImage: UIImage? = nil
            if let anImage = image?.cgImage {
                flippedImage = UIImage(cgImage: anImage, scale: (image?.scale)!, orientation: .upMirrored)
            }
            self.CameraView?.image = flippedImage
        }
    }}

