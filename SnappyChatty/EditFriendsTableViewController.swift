//
//  EditFriendsTableViewController.swift
//  SnappyChatty
//
//  Created by Anton Novoselov on 30/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Firebase

class EditFriendsTableViewController: UITableViewController {
    
    struct Storyboard {
        static let cellID = "Friend Cell"
    }
    
    var users = [User]()
    var selectedUsers = [String: User]()
//    var selectedUsers = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()

        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: {
            snapshot in
            
            if let users = snapshot.value as? [String: Any] {
                
                for (key, value) in users {
                    
                    print("===NAG=== key = \(key)")
                    print("===NAG=== value = \(value)")
                    
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
                print("===NAG=== self.users = \(self.users)")
                
                
            }
     
        
        })
        
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
        
        
        if selectedUsers.index(forKey: user.uid) != nil {
            userCell.accessoryType = .checkmark
        } else {
            userCell.accessoryType = .none
        }
        
        
        
        return userCell
    }
    
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
