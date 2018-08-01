//
//  ViewController.swift
//  ooomiji
//
//  Created by ominext on 7/30/18.
//  Copyright © 2018 ominext. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override var prefersStatusBarHidden: Bool { return true }

    @IBOutlet weak var startB: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        startB.layer.cornerRadius = startB.frame.height/2
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        print("disappear \(self)")
    }
}

