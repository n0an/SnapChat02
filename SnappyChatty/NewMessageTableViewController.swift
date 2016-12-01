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
        
        
        
    }
    
    
}










