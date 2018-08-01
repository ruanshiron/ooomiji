//
//  CameraViewController.swift
//  ooomiji
//
//  Created by ominext on 7/30/18.
//  Copyright © 2018 ominext. All rights reserved.
//

import Foundation
import UIKit
import Affdex
import AFNetworking

class CameraViewController: UIViewController, AFDXDetectorDelegate {
    override var prefersStatusBarHidden: Bool { return true }
    
    @IBOutlet weak var helloV: UIView!
    
    @IBOutlet weak var helloL: UILabel!
    
    @IBOutlet weak var errV: UIView!
    
    @IBOutlet weak var errL: UILabel!
    
    @IBOutlet weak var emoV: UIView!
    
    var hadKairos: Bool = false
    
    var detector: AFDXDetector?
    
    var face: Face?
    
    var time: Timer?
    
    
    @IBOutlet weak var CameraView: UIImageView!
    
    // AFDX Pr
    func detector(_ detector: AFDXDetector!, hasResults faces: NSMutableDictionary!, for image: UIImage!, atTime time: TimeInterval) { 

        // Face & Emotion Process
        if (nil == faces) {
            self.unprocessedImageReady(detector, image: image, atTime: time)
        }
        else {
            self.processedImageReady(detector, image: image, faces: faces, atTime: time)
            //self.unprocessedImageReady(detector, image: image, atTime: time)
        }
      
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleOutlets()
        
        createDetector()
      
    }
    
    @IBAction func close(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func joy(_ sender: Any) {
        self.face?.emotion = "happy"
        performSegue(withIdentifier: "toBye", sender: self)
    }
    
    @IBAction func sad(_ sender: Any) {
        self.face?.emotion = "sad"
        performSegue(withIdentifier: "toBye", sender: self)
    }
  
    @IBAction func fear(_ sender: Any) {
        self.face?.emotion = "fear"
        performSegue(withIdentifier: "toBye", sender: self)
    }

    @IBAction func anger(_ sender: Any) {
        self.face?.emotion = "angery"
        performSegue(withIdentifier: "toBye", sender: self)
    }
    
    @IBAction func valence(_ sender: Any) {
        self.face?.emotion = "valence"
        performSegue(withIdentifier: "toBye", sender: self)
    }
    
    @IBAction func neutral(_ sender: Any) {
        self.face?.emotion = "neutral"
        performSegue(withIdentifier: "toBye", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let ByeVC = segue.destination as? ByeViewController else {
            return
        }
        ByeVC.face = self.face
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        emoV.isHidden = true
        
        hadKairos = false
        
        face = Face()
        
        time = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("disappear \(self)")

        destroyDetector()
    }
    
    deinit {
        print("deinit \(self)")
    }

}

extension CameraViewController {
    func processedImageReady(_ detector: AFDXDetector?, image: UIImage?, faces: NSMutableDictionary!, atTime time: TimeInterval) {
//        print("\(faces.allValues.count)")
        if (hadKairos == false) {
            if (faces.allValues.count == 0) {
                return
            }
            if (!ConnectNetwork.connectedToNetwork()) {
                self.errL.text = "Không có kết nối!"
                
                //show err bar
                self.errV.isHidden = false
                print("Không có kết nối!")
                self.hadKairos = true
                return
            }
            
            self.errV.isHidden = true
            
            API.getKairos(for: image!) { (result, error) in
                DispatchQueue.main.async {
                    if (result == nil) {
                        let err = error as! String
                        print("\(err)")
                        //
                        self.errL.text = err
                        self.errV.isHidden = false
                        //
                        return
                    }
                    
                    let name = (result as! [String:String])["name"]
                    let face_id = (result as! [String:String])["face_id"]
                    
                    if (name != "") {
                        self.emoV.isHidden = false
                    }
                    
                    for face in faces.allValues {
                        let faceO = face as! AFDXFace
                        self.face = Face(name: name!, face_id: face_id!, face: faceO)
                    }
                    
                    print("----\(name!)")
                    self.helloL.text = "Chào \(name!)"
                }
            }
            self.hadKairos = true
            
        } else {
            for face in faces.allValues {
                let faceO = face as! AFDXFace

                self.face?.update(face: faceO)
            }
        }
        
        if (self.face != nil) {
            if (faces.allValues.count == 0) {
                if (self.time == nil) {
                    self.time = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(close(_:)), userInfo: nil, repeats: false)
                }
                return
            } else {
                self.time?.invalidate()
            }
        }
        
//        print("\(String(describing: self.face?.joy))")
    }
    
    func unprocessedImageReady(_ detector: AFDXDetector?, image: UIImage?, atTime time: TimeInterval) {
        DispatchQueue.main.async {
            var flippedImage: UIImage? = nil
            if let anImage = image?.cgImage {
                flippedImage = UIImage(cgImage: anImage, scale: (image?.scale)!, orientation: .upMirrored)
            }
            self.CameraView.image = flippedImage
        }
    }
    
    func destroyDetector() {
        _ = self.detector?.stop()
        
    }
    
    func createDetector() {
        self.destroyDetector()
        
        // Camera Device
        let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: AVCaptureDevice.Position.front)!
        
        
        // Capture from Camera
        self.detector = AFDXDetector(delegate: self, using: captureDevice, maximumFaces: 1, face: FaceDetectorMode.init(1))
        
        // detector set up
        self.detector?.maxProcessRate = 5
        self.detector?.setDetectAllEmotions(true)
        self.detector?.gender = true
        
        // START
        _ = self.detector?.start()
    }
}

extension CameraViewController {
    func styleOutlets() -> Void {
        errV.isHidden = true
        errV.layer.cornerRadius = errV.frame.height/2
        errV.layer.frame.origin.x = view.layer.frame.width
        
        helloV.layer.cornerRadius = helloV.frame.height/2
        
    
    }
    
    func passFace_showBye() -> Void {
    
    }
    
    func showErrorBar() -> Void {
        //
        UIView.animate(withDuration: 1) {
            self.errV.layer.frame.origin.x = 48
        }
    }
}
