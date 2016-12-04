//
//  StorageService.swift
//  SnappyChatty
//
//  Created by Anton Novoselov on 01/12/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import Firebase

let STORAGE_ROOT    = FIRStorage.storage().reference()
let IMAGES_REF      = "images"
let VIDEOS_REF      = "videos"


class StorageService {
    
    private static let _instance = StorageService()
    
    static var instance: StorageService {
        return _instance
    }
    
    // MARK: - PUBLIC PROPERTIES
    var REF_STORAGE_IMAGES = STORAGE_ROOT.child(IMAGES_REF)
    var REF_STORAGE_VIDEOS = STORAGE_ROOT.child(VIDEOS_REF)
    
    
}



