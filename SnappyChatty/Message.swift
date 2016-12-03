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
    
    var uid: String!
    var type: String // "image" or "video"

    var createdTime: Double!

    var recipients: [String]
    
    var createdByUsername: String
    
    var mediaURL: String
    
    var messageRef: FIRDatabaseReference
    
    // MARK: - Initializers
   
    init(type: String, recipients: [String], createdByUsername: String, mediaURL: String) {
        
        let allMessagesRef = DataService.instance.REF_MESSAGES
        
        self.uid = allMessagesRef.childByAutoId().key
        
        self.recipients = recipients
        
        self.type = type
        
        self.mediaURL = mediaURL
        
        self.createdByUsername = createdByUsername
        
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
    
    
    
    
    
    
    init(uid: String, dictionary: [String: Any]) {
        
        self.uid = uid
        
        self.type = dictionary["type"] as! String
        
        self.mediaURL = dictionary["mediaURL"] as! String

        self.createdTime = dictionary["createdTime"] as! Double

        self.createdByUsername = dictionary["createdByUsername"] as! String
     
        self.recipients = []
        
        if let recipientsDict = dictionary["recipients"] as? [String: Bool] {
            
            for (key, _) in recipientsDict {
                self.recipients.append(key)
            }
            
        }

        messageRef = DataService.instance.REF_MESSAGES.child(self.uid)
        
    }
    
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
            "createdByUsername" : createdByUsername,
            "createdTime": FIRServerValue.timestamp()
        ]
        
        messageRef.setValue(messageDict)
        
        for recipient in self.recipients {
            messageRef.child("\(RECIPIENTS_REF)/\(recipient)").setValue(true)

        }
        
        completion(nil)
        
        
    }
    
    
}

extension Message {
    
    func downloadMessageImage(completion: @escaping (UIImage?, Error?) -> Void) {
        
        FIRImage.downloadImage(forUrl: self.mediaURL, completion: { (image, error) in
            
            completion(image, error)
        
        
        })
        
        
        
    }
    
    class func observeMessages(_ completion: @escaping ([Message]) -> Void) {
        
        DataService.instance.REF_MESSAGES.queryOrdered(byChild: "createdTime").observe(.value, with: { snapshot in
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                var receivedMessages = [Message]()
                
                for snap in snapshot {
                    
                    if let messageDict = snap.value as? [String: Any] {
                        
                        let key = snap.key
                        let message = Message(uid: key, dictionary: messageDict)
                        
                        receivedMessages.append(message)
                        
                    }
                    
                    
                }
                completion(receivedMessages)
                
            }
            
        
        
        })
        
        
    }
    
    
    class func observeNewMessage(_ completion: @escaping (Message) -> Void) {
        

        
        DataService.instance.REF_MESSAGES.queryOrdered(byChild: "createdTime").observe(.childAdded, with: { snapshot in
            
            let msg = Message(uid: snapshot.key, dictionary: snapshot.value as! [String: Any])
            
            completion(msg)

        
        
        })
        
    }
    
    
    func removeRecipient(user: String) {
        
        // If there's only one recipient - delete ALL Message
        // If there're more than one recipient - delete just passed recipient
        
        if self.recipients.count == 1 {
            
            messageRef.removeValue()
            
        } else {
            
            if let indexRec = self.recipients.index(of: user) {
                self.recipients.remove(at: indexRec)
            }
            
            messageRef.child("\(RECIPIENTS_REF)/\(user)").removeValue()
        }
        
        
        
        
        
    }
    
    
    
}


// COMPARE METHOD (FOR "CONTAINS" FEATURE) - for checking if array constains current Message

extension Message: Equatable { }

func ==(lhs: Message, rhs: Message) -> Bool {
    return lhs.uid == rhs.uid
    
}
























