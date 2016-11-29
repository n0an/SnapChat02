//
//  InboxViewController.swift
//  SnappyChatty
//
//  Created by Anton Novoselov on 29/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Firebase

class InboxViewController: UITableViewController {
    
    struct Storyboard {
        static let loginVC = "ShowWelcomeViewController"
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FIRAuth.auth()?.currentUser == nil {
            performSegue(withIdentifier: Storyboard.loginVC, sender: nil)
        }

        
        
    }

    

}
