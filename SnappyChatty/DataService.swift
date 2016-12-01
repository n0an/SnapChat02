//
//  DataService.swift
//  SnappyChatty
//
//  Created by Anton Novoselov on 29/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import Firebase


let DB_ROOT         = FIRDatabase.database().reference()
let FRIENDS_REF     = "friends"
let RECIPIENTS_REF  = "recipients"

class DataService {
    
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    var REF_BASE        = DB_ROOT
    var REF_USERS       = DB_ROOT.child("users")
    var REF_MESSAGES    = DB_ROOT.child("messages")

    
    /*
    var mainStorageRef: FIRStorageReference {
        return FIRStorage.storage().reference(forURL: "gs://ducsya2-snapchat.appspot.com/")
    }
    
    var imagesStorageRef: FIRStorageReference {
        return mainStorageRef.child("images")
    }
    
    var videosStorageRef: FIRStorageReference {
        return mainStorageRef.child("videos")
    }
    
    
    
    func sendMediaPullRequest(senderUID: String, sendingTo:[String: User], mediaURL: URL, textSnippet: String? = nil) {
        
        var uids = [String: Any]()
        for uid in sendingTo.keys {
            uids[uid] = true
            
        }
        
        
        let pr: [String: Any] = [
            "mediaURL": mediaURL.absoluteString,
            "userID": senderUID,
            "openCount": 0,
            "recipients": uids
        ]
        
        mainRef.child("pullRequests").childByAutoId().setValue(pr)
        
    }
    */
    
}











