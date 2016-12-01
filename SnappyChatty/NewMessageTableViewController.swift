//
//  NewMessageTableViewController.swift
//  SnappyChatty
//
//  Created by Anton Novoselov on 01/12/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit

class NewMessageTableViewController: FriendsTableViewController {
    
    var mediaPickerHelper: MediaPickerHelper!
    
    var image: UIImage?
    var videoURL: URL?
    
    var recipients = [String: User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.tableView.allowsSelection = true
        
        mediaPickerHelper = MediaPickerHelper(viewController: self, completion: { (mediaObject) in
            
            if let videoURL = mediaObject as? URL {
                self.videoURL = videoURL
            } else if let snapshotImage = mediaObject as? UIImage {
                self.image = snapshotImage
            }
            
            
            
        })

        
    }
    
    // MARK: - ACTIONS
    
    @IBAction func cancel() {
        
        recipients.removeAll()
        image = nil
        videoURL = nil
        
        // Return to Tab #1
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func sendDidTap(_ sender: AnyObject) {
        
        if let videoURL = videoURL {
            
            sendVideoMessage(withVideoURL: videoURL)
            
        } else if let image = image {
            sendImageMessage(withImage: image)
        }
        
    }

    
    func sendVideoMessage(withVideoURL videoURL: URL) {
        
    }
    
    func sendImageMessage(withImage image: UIImage) {
        
        let firImage = FIRImage(image: image)
        
        firImage.saveToFirebaseStorage(completion: { (meta, error) in
        
            if error != nil {
                
                print("===NAG=== Unable to upload image to Firebase Storage")

            } else {
                print("===NAG=== Successfully image uploaded to Firebase Storage")

                
                let downloadURL = meta?.downloadURL()?.absoluteString // URL for this image in storage
                
                if let url = downloadURL {
                    
                    self.postMessage(withURL: url)
                    
                }
                
                
            }
        
        })
        
        
        
    }
    
    func postMessage(withURL imageURL: String) {
        
        var rec = [String]()
        
        for recipient in recipients {
            rec.append(recipient.key)
        }
        
        let message = Message(type: "image", recipients: rec, mediaURL: imageURL)
        
        message.save { (error) in
            
            if error != nil {
                print("===NAG=== Error adding message to Firebase Database")

            } else {
                print("===NAG=== Message with Image has been saved to Firebase Database")

            }
            
        }
        
        
    }
    
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        guard image == nil && videoURL == nil else { return }
//            
//       
//        mediaPickerHelper = MediaPickerHelper(viewController: self, completion: { (mediaObject) in
//            
//            if let videoURL = mediaObject as? URL {
//                self.videoURL = videoURL
//            } else if let snapshotImage = mediaObject as? UIImage {
//                self.image = snapshotImage
//            }
//            
//            
//            
//        })
//    }
    
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        self.image = nil
//        self.videoURL = nil
//        
//        
//    }
    
    
    deinit {
        self.image = nil
        self.videoURL = nil
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let userCell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellID, for: indexPath)
        
        let user = self.users[indexPath.row]
        
        userCell.textLabel?.text = user.username
        
        return userCell
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        let user = self.users[indexPath.row]
        
        
        if recipients.keys.contains(user.uid) {
            
            recipients.removeValue(forKey: user.uid)
            selectedCell?.accessoryType = .none
            
        } else {
            
            recipients[user.uid] = user
            selectedCell?.accessoryType = .checkmark
            
        }
        
        
        self.navigationItem.rightBarButtonItem?.isEnabled = self.recipients.count > 0
        
    }
    
    
}









