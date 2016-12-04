//
//  FIRVideo.swift
//  SnappyChatty
//
//  Created by Anton Novoselov on 01/12/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import Firebase

class FIRVideo {
    
    // MARK: - PROPERTIES
    var videoURL: URL
    
    // MARK: - INITIALILZERS
    init(videoURL: URL) {
        self.videoURL = videoURL
    }
    
    // MARK: - SAVE METHOD
    func saveToFirebaseStorage(completion: @escaping (FIRStorageMetadata?, Error?) -> Void) {
        let videoUid = NSUUID().uuidString
        let ref = StorageService.instance.REF_STORAGE_VIDEOS.child(videoUid)
        ref.putFile(self.videoURL, metadata: nil, completion: { meta, error in
            completion(meta, error)
        })
    }
}
