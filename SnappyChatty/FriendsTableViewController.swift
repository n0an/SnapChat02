//
//  FriendsTableViewController.swift
//  SnappyChatty
//
//  Created by Anton Novoselov on 01/12/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit

class FriendsTableViewController: UITableViewController {

    struct Storyboard {
        static let segueEditFriends = "Show Edit Friends"
        static let cellID = "Friend Cell"
    }
    
    var isEditingFriends: Bool = false

    var users = [User]()
    var selectedUsers = [String: Bool]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.allowsSelection = isEditingFriends
        
        DataService.instance.REF_USERS.observe(.value, with: {
            snapshot in
            
            if let users = snapshot.value as? [String: Any] {
                
                self.users = []
                
                for (key, value) in users {
                    
                    // 1. Check if we are in EditingFriends Mode. If we are in EditingFriends Mode, fetch all users
                    // 2. If we are NOT in EditingMode, fetch only friends user
                    
                    if !self.isEditingFriends {
                        let currentUser = AuthService.instance.currentUser
                        if currentUser.friends.index(forKey: key) == nil {
                            continue
                        }
                    }
                    
                    
                    if let profileDict = value as? [String: Any] {
                        
                        if let username = profileDict["username"] as? String,
                            let fullName = profileDict["fullName"] as? String {
                            let uid = key
                            let user = User(uid: uid, username: username, fullName: fullName, friends: [])
                            self.users.append(user)
                        }
                        
                    }
                    
                }
                
                self.tableView.reloadData()
                
            }
            
            
        })
        
    }
  
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.segueEditFriends {
            let destinationVC = segue.destination as! FriendsTableViewController
            
            destinationVC.isEditingFriends = true
        }
    }
    
    
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let userCell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellID, for: indexPath)
        
        let user = self.users[indexPath.row]
        
        userCell.textLabel?.text = user.username
        
        if self.isEditingFriends == true {
            if AuthService.instance.currentUser.isFriendWith(user: user) {
                userCell.accessoryType = .checkmark
            } else {
                userCell.accessoryType = .none
                
            }
        }
        
      
        
        return userCell
    }
    
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard self.isEditingFriends == true else {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let user = self.users[indexPath.row]
        
        if !AuthService.instance.currentUser.isFriendWith(user: user) {
            
            AuthService.instance.currentUser.addFriend(user: user.uid)
            
        } else {
            AuthService.instance.currentUser.removeFriend(user: user.uid)
            
        }
        
        tableView.reloadData()
       
     
    }

}
