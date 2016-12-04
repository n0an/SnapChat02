//
//  NewMessageTableViewController.swift
//  SnappyChatty
//
//  Created by Anton Novoselov on 01/12/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit

class NewMessageTableViewController: FriendsTableViewController {
    
    // MARK: - PROPERTIES
    var mediaPickerHelper: MediaPickerHelper!
    var image: UIImage?
    var videoURL: URL?
    var recipients = [String: User]()
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        self.tableView.allowsSelection = true
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard image == nil && videoURL == nil else { return }
        mediaPickerHelper = MediaPickerHelper(viewController: self, completion: { (mediaObject) in
            
            if let videoURL = mediaObject as? URL {
                self.videoURL = videoURL
            } else if let snapshotImage = mediaObject as? UIImage {
                self.image = snapshotImage
            } else {
                self.cancel()
            }
        })
    }
    
    // MARK: - HELPER METHODS
    func sendVideoMessage(withVideoURL videoURL: URL) {
        
        let firVideo = FIRVideo(videoURL: videoURL)
        
        firVideo.saveToFirebaseStorage { (meta, error) in
            
            if error != nil {
                print("===NAG=== Unable to upload video to Firebase Storage")
                
            } else {
                print("===NAG=== Successfully video uploaded to Firebase Storage")
                let downloadURL = meta?.downloadURL()?.absoluteString
                if let url = downloadURL {
                    self.postMessage(withMediaURLString: url, andMediaType: .Video)
                }
            }
        }
    }
    
    func sendImageMessage(withImage image: UIImage) {
        
        let firImage = FIRImage(image: image)
        
        firImage.saveToFirebaseStorage(completion: { (meta, error) in
            
            if error != nil {
                GeneralHelper.sharedHelper.showAlertOnViewController(viewController: self, withTitle: "Send Image Error", message: "Unable to upload image to Firebase Storage", buttonTitle: "OK")
            } else {
                let downloadURL = meta?.downloadURL()?.absoluteString // URL for this image in storage
                
                if let url = downloadURL {
                   
                    self.postMessage(withMediaURLString: url, andMediaType: .Image)
                }
            }
        })
    }
    
    func postMessage(withMediaURLString urlString: String, andMediaType mediaType: MessageMediaType) {
        var type: String
        
        switch mediaType {
        case .Video:
            type = "video"
            
        case .Image:
            type = "image"
        }
        
        var rec = [String]()
        
        for recipient in recipients {
            rec.append(recipient.key)
        }
        
        let currentUser = AuthService.instance.currentUser
        
        let message = Message(type: type, recipients: rec, createdByUsername: currentUser.fullName, mediaURL: urlString)
        
        message.save { (error) in
            if error != nil {
                GeneralHelper.sharedHelper.showAlertOnViewController(viewController: self, withTitle: "Adding Message Error", message: "Error adding message to Firebase Database", buttonTitle: "OK")
            } else {
                self.cancel()
            }
        }
    }
    
    // MARK: - ACTIONS
    @IBAction func cancel() {
        recipients.removeAll()
        image = nil
        videoURL = nil
        self.tableView.reloadData()
        
        // Return to Tab #1
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func sendDidTap(_ sender: AnyObject) {
        
        if let videoURL = videoURL {
            sendVideoMessage(withVideoURL: videoURL)
        } else if let image = image {
            sendImageMessage(withImage: image)
        }
        // Return to Tab #1
        self.tabBarController?.selectedIndex = 0
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let userCell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellID, for: indexPath)
        let user = self.users[indexPath.row]
        userCell.textLabel?.text = user.username
        
        if recipients.keys.contains(user.uid) {
            userCell.accessoryType = .checkmark
        } else {
            userCell.accessoryType = .none
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = self.recipients.count > 0

        return userCell
    }
    
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        let selectedUser = self.users[indexPath.row]
        
        if selectedCell?.accessoryType == .checkmark {
            // already selected, uncheck
            selectedCell?.accessoryType = .none
            
            if recipients.keys.contains(selectedUser.uid) {
                recipients.removeValue(forKey: selectedUser.uid)
            }
            
        } else {
            // isn't selected, check
            
            selectedCell?.accessoryType = .checkmark
            
            if !recipients.keys.contains(selectedUser.uid) {
                recipients[selectedUser.uid] = selectedUser
            }
        }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = self.recipients.count > 0
    }
    
}


