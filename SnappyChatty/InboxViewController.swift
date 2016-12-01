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
    
    var currentUser: User!
    
    struct Storyboard {
        static let loginVC = "ShowWelcomeViewController"
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // check if the user logged in or not
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                // signed in
                
                DataService.instance.REF_USERS.child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let userDict = snapshot.value as? [String: Any] {
                        
                        self.currentUser = User(uid: user.uid, dictionary: userDict)

                        print("===NAG===: currentUser = \(self.currentUser?.username)")
                        
                        AuthService.instance.currentUser = self.currentUser
                        
                        // §§ Fetch Messages
                    }
                    
                })
                
                
            } else {
                self.performSegue(withIdentifier: Storyboard.loginVC, sender: nil)
            }
        })

        
   
        
        
        
    }
    
    
    @IBAction func actionLogoutTapped() {
    
        try! FIRAuth.auth()?.signOut()
        
//        self.tabBarController?.selectedIndex = 0
        performSegue(withIdentifier: Storyboard.loginVC, sender: nil)

    
    
    }

    

}



















