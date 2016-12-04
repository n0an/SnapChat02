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
let USERS_REF       = "users"
let MESSAGES_REF    = "messages"
let FRIENDS_REF     = "friends"
let RECIPIENTS_REF  = "recipients"

class DataService {
    
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    // MARK: - PUBLIC PROPERTIES
    var REF_BASE        = DB_ROOT
    var REF_USERS       = DB_ROOT.child(USERS_REF)
    var REF_MESSAGES    = DB_ROOT.child(MESSAGES_REF)

}











