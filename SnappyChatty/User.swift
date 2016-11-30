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
    
    let uid: String
    var username: String
    var fullName: String
    
    var friends: [User]
    
    // MARK: - Initializers
    
    init(uid: String, username: String, fullName: String, friends: [User]) {
        self.uid =      uid
        self.username = username
        self.friends =  friends
        self.fullName = fullName
    }
    
    
    func toDictionary() -> [String: Any] {
        return [
            "uid":      uid,
            "username": username,
            "fullName": fullName
        ]
        
        
    }
    
    
    func save(completion: @escaping modelCompletion) {
        
        let dataService = DataService.instance
        
        let ref = dataService.REF_USERS.child(uid)
        ref.setValue(toDictionary())
        
        
    }
    
}
































