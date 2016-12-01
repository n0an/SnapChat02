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
    
    var messages = [Message]()
    
    struct Storyboard {
        static let segueLogin = "ShowWelcomeViewController"
        static let seguePhotoDisplayer = "Show Photo"
        static let cellID = "Message Cell"

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
                        
                        self.fetchMessages()
                        
                    }
                    
                })
                
                
            } else {
                self.performSegue(withIdentifier: Storyboard.segueLogin, sender: nil)
            }
        })

        
        
    }
    
    
    func fetchMessages() {
        
        self.messages = []
        
        Message.observeNewMessage { (message) in
            
            if message.recipients.contains(self.currentUser.uid) && !self.messages.contains(message) {
                self.messages.insert(message, at: 0)
                self.tableView.reloadData()
            }
        
        }
        
    }
    
    
    
    
    @IBAction func actionLogoutTapped() {
    
        try! FIRAuth.auth()?.signOut()
        
        performSegue(withIdentifier: Storyboard.segueLogin, sender: nil)

    }
    
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.seguePhotoDisplayer {
            let destinationVC = segue.destination as! PhotoViewController
            destinationVC.message = sender as! Message
        }
    }
    
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messageCell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellID, for: indexPath)
        
        let message = self.messages[indexPath.row]
        
        messageCell.textLabel?.text = "\((message.createdTime)!)"
        
        
        
        
        return messageCell
        
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedMsg = self.messages[indexPath.row]
        
        self.performSegue(withIdentifier: Storyboard.seguePhotoDisplayer, sender: selectedMsg)
        
    }
    

}



















