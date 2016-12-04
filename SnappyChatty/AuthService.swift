//
//  AuthService.swift
//  SnappyChatty
//
//  Created by Anton Novoselov on 29/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import Firebase

typealias CompletionHandler = (String?, Any?) -> Void

class AuthService {
    
    private static let _instance = AuthService()
    
    static var instance: AuthService {
        return _instance
    }
    
    private var _currentUser: User!

    var currentUser: User {
        set {
            _currentUser = newValue
        } get {
            return _currentUser
        }
    }
    
    // MARK: - Sign Up Method
  
    func signUp(withEmail email: String, username: String, fullName: String, password: String, onComplete: CompletionHandler?) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (firCreatedUser, error) in
            if error != nil {
                // report error
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                
            } else if let firCreatedUser = firCreatedUser {
                
                let newUser = User(uid: firCreatedUser.uid, username: username, fullName: fullName, friends: [])

                newUser.save(completion: { (error) in
                    if error != nil {
                        // report error
                        print("===NAG=== SAVE USER ERROR: \(error!.localizedDescription)")
                        self.handleFirebaseError(error: error as! NSError, onComplete: onComplete)
                        
                    } else {
                        
                        self.completeSignIn(withEmail: email, password: password, onComplete: onComplete)
                    }
                })
            }
        })
    }
    
    // MARK: - Log In Method
    func loginToFireBase(withEmail email: String, password: String, onComplete: CompletionHandler?) {
        self.completeSignIn(withEmail: email, password: password, onComplete: onComplete)
    }
    
    // MARK: - Helper Methods
    func completeSignIn(withEmail email: String, password: String, onComplete: CompletionHandler?) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (firSignedUser, error) in
            if let error = error {
                self.handleFirebaseError(error: error as NSError, onComplete: onComplete)
            } else {
                // We have successfully logged in
                onComplete?(nil, firSignedUser)
            }
        })
    }
    
    
    // MARK: - Handle Firebase Errors
    func handleFirebaseError(error: NSError, onComplete: CompletionHandler?) {
        print("===NAG=== \(error.localizedDescription)")

        if let errorCode = FIRAuthErrorCode(rawValue: error.code) {
            switch errorCode {
            case .errorCodeInvalidEmail:
                onComplete?("Invalid email address", nil)
                
            case .errorCodeWrongPassword:
                onComplete?("Invalid password", nil)
                
            case .errorCodeAccountExistsWithDifferentCredential:
                fallthrough
            case .errorCodeEmailAlreadyInUse:
                onComplete?("Email already in use", nil)
                
            default:
                onComplete?("There was a problem authenticating. Try again", nil)
            }
        }
        
        onComplete?(error.localizedDescription, nil)
    }
    
}











