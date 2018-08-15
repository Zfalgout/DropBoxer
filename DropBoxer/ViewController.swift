//
//  ViewController.swift
//  DropBoxer
//
//  Created by Zack Falgout on 8/14/18.
//  Copyright © 2018 Zack Falgout. All rights reserved.
//

import UIKit
import SwiftyDropbox

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func connectToDB(_ sender: Any) {
    
        DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                      controller: self,
                                                      openURL: { (url: URL) -> Void in
                                                        UIApplication.shared.openURL(url)
        })
    
    }
    
}

