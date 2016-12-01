//
//  User.swift
//  SnappyChatty
//
//  Created by Anton Novoselov on 29/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import Firebase

typealias modelCompletion = (Error?) -> Void

class User {
    
    var uid: String
    var username: String
    var fullName: String
    
    var friends: [String]
    
    
    var userRef: FIRDatabaseReference
    
    // MARK: - Initializers
    
    init(uid: String, username: String, fullName: String, friends: [String]) {
        self.uid =      uid
        self.username = username
        self.friends =  friends
        self.fullName = fullName
        
        userRef = DataService.instance.REF_USERS.child(self.uid)
        
        
    }
    
    init(uid: String, dictionary: [String: Any]) {
        
        self.uid = uid
        
        self.username = dictionary["username"] as! String
        self.fullName = dictionary["fullName"] as! String
        
        self.friends = []
        
        if let friendsDict = dictionary["friends"] as? [String: Any] {
            
            for (key, _) in friendsDict {
                
                self.friends.append(key)
                
            }
            
        }
        
        userRef = DataService.instance.REF_USERS.child(self.uid)
        
    }
    
    
    func toDictionary() -> [String: Any] {
        return [
            
            "username": username,
            "fullName": fullName
        ]
        
        
    }
    
    
    func save(completion: @escaping modelCompletion) {
        
        // 1. Save general profile data
        
        userRef.setValue(toDictionary())
        
        // 2. Save friends
        
        for friend in friends {
            
            userRef.child("\(FRIENDS_REF)/\(friend)").setValue(true)
            
        }
        
        completion(nil)
        
    }
    
}



extension User {
    
    func addFriend(user: String) {
        self.friends.append(user)
        
        userRef.setValue(true)
        
    }
    
    
}




























