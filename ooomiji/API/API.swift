//
//  API.swift
//  omoji
//
//  Created by ominext on 7/24/18.
//  Copyright © 2018 ominext. All rights reserved.
//

import Foundation
import UIKit

typealias completionBlock = ((AnyObject?, AnyObject?)->Void)

struct KairosConfig {
    static let app_id = "863c4565"
    static let app_key = "a2f516bdebb57d3b209727efa33f98d8"
}

class API {
    
    class func postEmo(param: [String:AnyObject]?, callBack: CompletionRequest) {
        NetWork.shared2.requestWith(method: .Post, apiName: "request.php", param: param, callBack: callBack)
    }
    
    class func getAdvice(param: [String: Any]?, callBack: CompletionRequest) {
        NetWork.shared.requestWith(method: .Post, apiName: ApiNameImageRequest, param: param, callBack: callBack)
    }
    
    class func sadSend (param: [String: Any]?, callBack: CompletionRequest) {
        NetWork.shared3.requestWith(method: .Post, apiName: ApiNameImageRequest, param: param, callBack: callBack)
    }

    
    class func getKairos(for image: UIImage, _ callback: @escaping completionBlock) -> Void {
        let Kairos = KairosAPI(app_id: KairosConfig.app_id, app_key: KairosConfig.app_key)
        
        let base64ImageData = Kairos.convertImageToBase64String(image: image)
        
        // setup json request params, with base64 data
        let jsonBodyDetect = [
            "image": base64ImageData,
            "gallery_name": "Ominext"
        ]
        
        Kairos.request(method: "recognize", data: jsonBodyDetect) { (data, error) in
            if let image = (data as? [String : AnyObject])!["images"]{
                // Parsing Response
                var images = image as! [AnyObject]
                let transaction = (images[0] as? [String : AnyObject])!["transaction"]!
                
                var passdata = [String:String]()
                passdata["name"] = (transaction as? [String : AnyObject])?["subject_id"] as? String
                passdata["face_id"] = (transaction as? [String : AnyObject])?["face_id"] as? String
                print(data)
                if passdata["name"] != nil {
                    //print("Hello \(String(describing: passdata["name"]))")
                    callback(passdata as AnyObject, nil)
                } else {
                    print(error as Any)
                    let errorContent = Kairos.stringError(errors: error)
                    callback(nil, errorContent as AnyObject)
                }
            }
            else {
                print(error as Any)
                let errorContent = Kairos.stringError(errors: error)
                callback(nil, errorContent as AnyObject)
            }
        }
    }
}
