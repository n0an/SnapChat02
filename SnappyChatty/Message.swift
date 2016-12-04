//
//  Message.swift
//  SnappyChatty
//
//  Created by Anton Novoselov on 01/12/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import Firebase

enum MessageMediaType {
    case Video
    case Image
}

class Message {
    
    // MARK: - PROPERTIES
    var uid: String!
    var type: String // "image" or "video"
    var createdTime: Double!
    var recipients: [String]
    var createdByUsername: String
    var mediaURL: String
    
    var messageRef: FIRDatabaseReference
    
    // MARK: - INITIALIZERS
    init(type: String, recipients: [String], createdByUsername: String, mediaURL: String) {
        let allMessagesRef = DataService.instance.REF_MESSAGES
        self.uid = allMessagesRef.childByAutoId().key
        self.recipients = recipients
        self.type = type
        self.mediaURL = mediaURL
        self.createdByUsername = createdByUsername
        messageRef = allMessagesRef.child(self.uid)
    }
    
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
    
    // MARK: - SAVE METHOD
    func toDictionary() -> [String: Any] {
        return [
            "mediaURL": mediaURL,
            "type" : type,
            "createdByUsername" : createdByUsername,
            "createdTime": FIRServerValue.timestamp()
        ]
    }
    
    func save(completion: @escaping modelCompletion) {
        messageRef.setValue(toDictionary())
        
        for recipient in self.recipients {
            messageRef.child("\(RECIPIENTS_REF)/\(recipient)").setValue(true)
        }
        completion(nil)
    }
}

extension Message {
    
    // MARK: - Download Image File in Storage
    func downloadMessageImage(completion: @escaping (UIImage?, Error?) -> Void) {
        FIRImage.downloadImage(forUrl: self.mediaURL, completion: { (image, error) in
            completion(image, error)
        })
    }
    
    // MARK: - Observe (Get) messages from Database
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
    
    // MARK: - Observe (Get) ONLY new added message from Database
    class func observeNewMessage(_ completion: @escaping (Message) -> Void) {
        
        DataService.instance.REF_MESSAGES.queryOrdered(byChild: "createdTime").observe(.childAdded, with: { snapshot in
            let msg = Message(uid: snapshot.key, dictionary: snapshot.value as! [String: Any])
            completion(msg)
        })
    }
    
    // MARK: - Remove Recipient
    func removeRecipient(user: String) {
        
        // If there's only one recipient - delete ALL Message
        // If there're more than one recipient - delete just passed recipient
        
        if self.recipients.count == 1 {
            removeMediaFileFromFirebaseStorage()
            messageRef.removeValue()
        } else {
            if let indexRec = self.recipients.index(of: user) {
                self.recipients.remove(at: indexRec)
            }
            messageRef.child("\(RECIPIENTS_REF)/\(user)").removeValue()
        }
    }
    
    func removeMediaFileFromFirebaseStorage() {
        
        let ref = FIRStorage.storage().reference(forURL: self.mediaURL)
        
        ref.delete { (error) in
            if error != nil {
                print("===NAG=== Error Deleting File from Firebase Storage \(error?.localizedDescription)")
            }
        }
    }
}


// COMPARE METHOD (FOR "CONTAINS" FEATURE) - for checking if array constains current Message
extension Message: Equatable { }
func ==(lhs: Message, rhs: Message) -> Bool {
    return lhs.uid == rhs.uid
}

