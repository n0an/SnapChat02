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
    
    var friends: [String: Bool]
    
    
    var userRef: FIRDatabaseReference
    
    // MARK: - Initializers
    
    init(uid: String, username: String, fullName: String, friends: [String]) {
        self.uid =      uid
        self.username = username
        
        self.friends = [:]
        
        for friend in friends {
            self.friends[friend] = true
        }
        
        self.fullName = fullName
        
        userRef = DataService.instance.REF_USERS.child(self.uid)
        
        
    }
    
    init(uid: String, dictionary: [String: Any]) {
        
        self.uid = uid
        
        self.username = dictionary["username"] as! String
        self.fullName = dictionary["fullName"] as! String
        
        self.friends = [:]
        
        if let friendsDict = dictionary["friends"] as? [String: Bool] {
            self.friends = friendsDict
        }
        
//        if let friendsDict = dictionary["friends"] as? [String: Any] {
//            
//            for (key, ) in friendsDict {
//                
//                self.friends.append(key)
//                
//            }
//            
//        }
        
        userRef = DataService.instance.REF_USERS.child(self.uid)
        
    }
    
    
    func toDictionary() -> [String: Any] {
        return [
            
            "username": username,
            "fullName": fullName
        ]
        
        
    }
    
    func isFriendWith(user: User) -> Bool {
        
        if self.friends.index(forKey: user.uid) != nil {
            return true
        } else {
            return false
        }
        
    }
    
    
    func save(completion: @escaping modelCompletion) {
        
        // 1. Save general profile data
        
        userRef.setValue(toDictionary())
        
        // 2. Save friends
        
        for friend in friends.keys {
            
            userRef.child("\(FRIENDS_REF)/\(friend)").setValue(true)
            
        }
        
        completion(nil)
        
    }
    
}



extension User {
    
    func addFriend(user: String) {
        self.friends.updateValue(true, forKey: user)
        
        userRef.child("\(FRIENDS_REF)/\(user)").setValue(true)
        
    }
    
    
    func removeFriend(user: String) {
        self.friends.removeValue(forKey: user)
        
        userRef.child("\(FRIENDS_REF)/\(user)").removeValue()
        
    }
    
}


// COMPARE METHOD (FOR "CONTAINS" FEATURE) - for checking if array constains current User

extension User: Equatable { }

func ==(lhs: User, rhs: User) -> Bool {
    return lhs.uid == rhs.uid
    
}
























