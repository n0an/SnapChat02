//
//  WelcomeViewController.swift
//  SnappyChatty
//
//  Created by Anton Novoselov on 29/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            
            guard user != nil else {
                return
            }
            
            self.dismiss(animated: false, completion: nil)
            
//            if let user = user {
//                
//                self.dismiss(animated: false, completion: nil)
//            } else {
//                
//            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
