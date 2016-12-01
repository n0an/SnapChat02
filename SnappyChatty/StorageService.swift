//
//  StorageService.swift
//  SnappyChatty
//
//  Created by Anton Novoselov on 01/12/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import Firebase

let STORAGE_ROOT =  FIRStorage.storage().reference()

class StorageService {
    
    static let instance = StorageService()
    
    var REF_STORAGE_IMAGES = STORAGE_ROOT.child("images")
    var REF_STORAGE_VIDEOS = STORAGE_ROOT.child("videos")
    
    
}



