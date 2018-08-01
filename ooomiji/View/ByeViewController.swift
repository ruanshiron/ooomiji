//
//  ByeViewController.swift
//  ooomiji
//
//  Created by ominext on 7/31/18.
//  Copyright © 2018 ominext. All rights reserved.
//

import Foundation
import UIKit

class ByeViewController: UIViewController {
    override var prefersStatusBarHidden: Bool { return true }
    
    var face: Face?
    
    @IBOutlet weak var helloL: UILabel!
    
    @IBOutlet weak var adviceL: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        var param = Dictionary<String , AnyObject>()
        param["advice"] = face?.emotion as AnyObject
        param["emotion_detect"] = face?.realemotion() as AnyObject
        param["emotion"] = face?.emotion! as AnyObject
        param["face_id"] = face?.face_id as AnyObject
        
        API.getAdvice(param: param) { (result) in
            print(result.data ?? "-----")
            guard let dict = (result.data as? [String: Any]) else {return}
            guard let items = (dict["items"] as? String) else {return}
            
            self.adviceL.text = items
        }
        
        API.postEmo(param: param) { (result) in
            //
        }
        
        API.sadSend(param: param) { (Res) in
            
        }
        
        helloL.text = "Chào \(face?.name ?? "Ai đó :)")"
        
        //
        print(face?.emotion! ?? "")
        print(face?.face_id ?? "")
        print("---\(String(describing: face?.realemotion()))" )
        
        _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(close(_:)), userInfo: nil, repeats: false)
    }
    
    @IBAction func close(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
