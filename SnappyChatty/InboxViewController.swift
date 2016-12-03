//
//  InboxViewController.swift
//  SnappyChatty
//
//  Created by Anton Novoselov on 29/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import AVKit

class InboxViewController: UITableViewController {
    
    var currentUser: User!
    
    var messages = [Message]()
    
    var selectedMsg: Message!
    
    struct Storyboard {
        static let segueLogin = "ShowWelcomeViewController"
        static let seguePhotoDisplayer = "Show Photo"
        static let cellID = "Message Cell"

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // check if the user logged in or not
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                // signed in
                
                DataService.instance.REF_USERS.child(user.uid).observe(.value, with: { (snapshot) in
                    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    // MARK: - Helper Methods
    
    func fetchMessages() {
        
        self.messages = []
        
        Message.observeMessages { (fetchedMessages) in
            
            for msg in fetchedMessages {
                if msg.recipients.contains(self.currentUser.uid) && !self.messages.contains(msg) {
                    self.messages.insert(msg, at: 0)
                }
            }
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            
        }
        
        
        
        
//        Message.observeNewMessage { (messages) in
//            
//            
//            
//            
////            if message.recipients.contains(self.currentUser.uid) && !self.messages.contains(message) {
////                self.messages.insert(message, at: 0)
////                self.tableView.reloadData()
////            }
//        
//        }
        
    }
    
    func downloadImage(forSelectedMessage message: Message) {
        
        message.downloadMessageImage(completion: { (image, error) in
            
            if error == nil {
                self.selectedMsg = message
                self.performSegue(withIdentifier: Storyboard.seguePhotoDisplayer, sender: image!)
                
            } else {
                
                GeneralHelper.sharedHelper.showAlertOnViewController(viewController: self, withTitle: "Error", message: error!.localizedDescription, buttonTitle: "OK")
            }
        })
    }
    
    
    func playVideo(fromSelectedMessage message: Message) {
        
        let videoURL = URL(string: message.mediaURL)
        
        let player = AVPlayer(url: videoURL!)
        
        let playerVC = AVPlayerViewController()
        
        playerVC.player = player
        
        
        self.present(playerVC, animated: true, completion: {
            playerVC.player?.play()
        
        })
        
        
        
    }

    
    func clearFriendsAndRecipientsLists() {
        
        let ad = UIApplication.shared.delegate as! AppDelegate
        let tabBarController = ad.window?.rootViewController as! UITabBarController
        let firstNavVC = tabBarController.viewControllers?.first as! UINavigationController
        let secondNavVC = tabBarController.viewControllers?[1] as! UINavigationController
        let thirdNavVC = tabBarController.viewControllers?[2] as! UINavigationController

        let inboxVC = firstNavVC.topViewController as! InboxViewController
        let newMsgVC = secondNavVC.topViewController as! NewMessageTableViewController
        let friendsVC = thirdNavVC.topViewController as! FriendsTableViewController
        
        inboxVC.messages = []
        inboxVC.tableView.reloadData()
        
        newMsgVC.users = []
        newMsgVC.recipients = [:]
        newMsgVC.tableView.reloadData()
        
        friendsVC.users = []
        friendsVC.selectedUsers = [:]
        friendsVC.tableView.reloadData()
        
    }
    
    
    
    // MARK: - Actions
    
    @IBAction func actionLogoutTapped() {
    
        try! FIRAuth.auth()?.signOut()
        
        clearFriendsAndRecipientsLists()
        
        performSegue(withIdentifier: Storyboard.segueLogin, sender: nil)

    }
    
    @IBAction func refreshControlValueChanged() {
        fetchMessages()
        
        self.fetchMessages()

    }
    
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.seguePhotoDisplayer {
            let destinationVC = segue.destination as! PhotoViewController
            
            destinationVC.hidesBottomBarWhenPushed = true
            
            
            let sendImg = sender as! UIImage
            
            destinationVC.message = selectedMsg
            destinationVC.image = sendImg
      
            
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
        
        let messageCell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellID, for: indexPath) as! MessageCell
        
        let message = self.messages[indexPath.row]
        
        messageCell.configureCell(message: message)
        
        return messageCell
        
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedMsg = self.messages[indexPath.row]
        
        if selectedMsg.type == "image" {
            
            self.downloadImage(forSelectedMessage: selectedMsg)
            
        } else if selectedMsg.type == "video" {
            self.playVideo(fromSelectedMessage: selectedMsg)
        }
        
        selectedMsg.removeRecipient(user: currentUser.uid)
        
        
    }
    

}



















