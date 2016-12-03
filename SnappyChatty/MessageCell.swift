//
//  MessageCell.swift
//  SnappyChatty
//
//  Created by Anton Novoselov on 02/12/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Firebase

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var messageTypeLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(message: Message) {
        
        self.userFullNameLabel.text = message.createdByUsername
        self.messageTypeLabel.text = message.type
        
//        let createdAt = (String)(message.createdTime)
        
        let timeInterval = TimeInterval(message.createdTime / 1000)
        
        let createdDate = NSDate(timeIntervalSince1970: timeInterval)
        
        
        self.timestampLabel.text = createdDate.stringFromDate()
        
        
    }
    
    
    

}



fileprivate extension NSDate {
    func stringFromDate() -> String {
        let interval = NSDate().days(after: self as Date!)
        var dateString = ""
        
        if interval == 0 {
            dateString = "Today"
        } else if interval == 1 {
            dateString = "Yesterday"
        } else if interval > 1 {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy"
            dateString = dateFormat.string(from: self as Date)
        }
        
        return dateString
    }
}
















