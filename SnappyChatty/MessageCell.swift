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
        
        self.timestampLabel.text = "Today"
        
        
    }
    
    
    

}
