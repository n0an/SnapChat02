//
//  Message.swift
//  SnappyChatty
//
//  Created by Anton Novoselov on 01/12/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import Firebase

class Message {
    
    var uid: String
    var type: String // "image" or "video"

    var createdTime: String!

    var recipients: [String]
    
    var mediaURL: String!
    
    var messageRef: FIRDatabaseReference
    
    // MARK: - Initializers
   
    init(type: String, recipients: [String], mediaURL: String) {
        
        let allMessagesRef = DataService.instance.REF_MESSAGES
        
        self.uid = allMessagesRef.childByAutoId().key
        
        self.recipients = recipients
        
        self.type = type
        
        self.mediaURL = mediaURL
        
        messageRef = allMessagesRef.child(self.uid)
        
    }
    
    
    
    
    
    
//    init(uid: String, type: String, caption: String, createdTime: String, recipients: [User], mediaURL: String) {
//        
//        self.uid = uid
//        self.type = type
//        self.caption = caption
//        self.createdTime = createdTime
//        
////        self.createdBy = createdBy
//        
//        self.recipients = [:]
//        
//        for recipient in recipients {
//            self.recipients[recipient.uid] = true
//        }
//        
//        self.mediaURL = mediaURL
//        
//        messageRef = DataService.instance.REF_MESSAGES.child(self.uid)
//        
//    }
//    
//    init(uid: String, dictionary: [String: Any]) {
//        
//        self.uid = uid
//        
//        self.type = dictionary["type"] as! String
//        
//        self.caption = dictionary["caption"] as! String
//        self.mediaURL = dictionary["mediaURL"] as! String
//        self.createdTime = dictionary["createdTime"] as! String
//        
//        
//        self.recipients = [:]
//        
//        if let recipientsDict = dictionary["recipients"] as? [String: Bool] {
//            self.recipients = recipientsDict
//        }
//        
//        
//        messageRef = DataService.instance.REF_MESSAGES.child(self.uid)
//        
//    }
    
//    func toDictionary() -> [String: Any] {
//        
//        return [
//        
//            "type" : type,
//            "caption" : caption,
//            "createdTime": FIRServerValue.timestamp()
//            
//        ]
//        
//    }
    
    func save(completion: @escaping modelCompletion) {
        
        let messageDict: [String: Any] = [
            
            "mediaURL": mediaURL,
            "type" : type,
            "createdTime": FIRServerValue.timestamp()
        ]
        
        messageRef.setValue(messageDict)
        
        for recipient in self.recipients {
            messageRef.child("\(RECIPIENTS_REF)/\(recipient)").setValue(true)

        }
        
        completion(nil)
        
        
    }
    
    
}







