//
//  Emotion.swift
//  ooomiji
//
//  Created by ominext on 7/30/18.
//  Copyright © 2018 ominext. All rights reserved.
//

import Foundation
import UIKit
import Affdex

class Face: NSObject {
    
    var name: String = ""
    var face_id: String = ""
    var female: Bool = false
    var glasses: Bool = false
    var joy: Float = 0
    var anger: Float = 0
    var fear: Float = 0
    var surprise: Float = 0
    var sadness: Float = 0
    var valence: Float = 0
    var disgust: Float = 0
    var contempt: Float = 0
    
    var emotion: String?
    
    init(name: String, face_id: String, face: AFDXFace) {
        self.name = name
        self.face_id = face_id
        
        
        self.joy = Float(face.emotions.joy)
        self.anger = Float(face.emotions.anger)
        self.fear = Float(face.emotions.fear)
        self.surprise = Float(face.emotions.surprise)
        self.sadness = Float(face.emotions.sadness)
        self.valence = Float(face.emotions.valence)
        self.disgust = Float(face.emotions.disgust)
        self.contempt = Float(face.emotions.contempt)
        
        self.glasses = face.appearance.glasses == AFDX_GLASSES_YES ? true : false
        
        self.female = face.appearance.gender == AFDX_GENDER_FEMALE ? true : false
    }
    
    func update(face: AFDXFace) -> Void {
        self.joy = Float(face.emotions.joy)/2 + self.joy/2
        self.anger = Float(face.emotions.anger)/2 + self.anger/2
        self.fear = Float(face.emotions.fear)/2 + self.fear/2
        self.surprise = Float(face.emotions.surprise)/2 + self.surprise/2
        self.sadness = Float(face.emotions.sadness)/2 + self.sadness/2
        self.valence = Float(face.emotions.valence)/2 + self.valence/2
        self.disgust = Float(face.emotions.disgust)/2 + self.disgust/2
        self.contempt = Float(face.emotions.contempt)/2 + self.contempt/2
        
        self.glasses = face.appearance.glasses == AFDX_GLASSES_YES ? true : false
        
        self.female = face.appearance.gender == AFDX_GENDER_FEMALE ? true : false
    }
    
    override init() {
        
    }
    
    func realemotion() -> String? {
        var emo = Dictionary<String,Float>()
        emo["joy"] = self.joy
        emo["anger"] = self.anger
        emo["fear"] = self.fear
        emo["sadness"] = self.sadness
        emo["surprise"] = self.surprise
        emo["neutral"] = 1 - self.joy - self.anger - self.fear - self.surprise - self.sadness
        let greatest = emo.max { a, b in a.value < b.value }
        let emoM = greatest?.key 
        return emoM
    }
    
    deinit {
        print("deinit \(self)")
    }
}
