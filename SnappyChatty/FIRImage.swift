//
//  FIRImage.swift
//  SnappyChatty
//
//  Created by Anton Novoselov on 01/12/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import Firebase


class FIRImage {
    
    var image: UIImage
//    var downloadURL: URL?
//    var downloadLink: String!
    var ref: FIRStorageReference!
    
    init(image: UIImage) {
        self.image = image
    }
    
    func saveToFirebaseStorage(completion: @escaping (FIRStorageMetadata?, Error?) -> Void) {
        
        let imageUid = NSUUID().uuidString
        
        let resizedImage = image.resized()
        let imageData = UIImageJPEGRepresentation(resizedImage, 0.9)
        
        ref = StorageService.instance.REF_STORAGE_IMAGES.child(imageUid)
        
        ref.put(imageData!, metadata: nil, completion: { (meta, error) in
        
            completion(meta, error)
        
        })
        
        
        
        
    }
    
}

extension FIRImage {
    
    class func downloadImage(forUrl url: String, completion: @escaping (UIImage?, Error?) -> Void) {
        
        let ref = FIRStorage.storage().reference(forURL: url)
        
        ref.data(withMaxSize: 2 * 1024 * 1024, completion: { data, error in
        
            if error != nil {
                print("===NAG=== Unable to download image from Firebase storage")
            } else {
                print("===NAG=== Image downloaded from Firebase storage")
                
                if let imageData = data {
                    if let img = UIImage(data: imageData) {
                        
                        completion(img, error)
                    }
                } else {
                    completion(nil, error)
                }
            }
            
        
        })
        
        
    }
    
    
    class func removeImage(forUrl url: String, completion: @escaping (Error?) -> Void) {
        
        let ref = FIRStorage.storage().reference(forURL: url)
        
        ref.delete { (error) in
            
            completion(error)
            
            
        }
        
        
    }
    
}


private extension UIImage {
    
    func resized() -> UIImage {
        let height: CGFloat = 800.0
        let ratio = self.size.width / self.size.height
        
        let width = height * ratio
        
        let newSize = CGSize(width: width, height: height)
        
        let newRectangle = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContext(newSize)
        
        self.draw(in: newRectangle)
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }
    
}






