//
//  LoginViewController.swift
//  SnappyChatty
//
//  Created by Anton Novoselov on 29/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit

import UIKit
import Firebase

class LoginViewController: UITableViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Login to SnappyChatty"
        
        emailTextField.becomeFirstResponder()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func actionLoginDIdTap() {
        
        if emailTextField.text != "" && (passwordTextField.text?.characters.count)! > 6 {
            let email = emailTextField.text!
            let password = passwordTextField.text!
            
            
            AuthService.instance.loginToFireBase(withEmail: email, password: password, onComplete: { (errMsg, data) in
                
                guard errMsg == nil else {
                    self.showAlert(title: "Oops!", message: errMsg!, buttonTitle: "OK")
                    
                    return
                }
                
                self.dismiss(animated: true, completion: nil)
                
                
            })
            
            
            
//            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (firUser, error) in
//                if let error = error {
//                    self.showAlert(title: "Oops!", message: error.localizedDescription, buttonTitle: "OK")
//                } else {
//                    self.dismiss(animated: true, completion: nil)
//                }
//            })
        }
        
        
    }
    
    func showAlert(title: String, message: String, buttonTitle: String) {
        
        GeneralHelper.sharedHelper.showAlertOnViewController(viewController: self, withTitle: title, message: message, buttonTitle: buttonTitle)
        
    }
    
    
    
    
    
    @IBAction func actionBackDidTap(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            textField.resignFirstResponder()
            actionLoginDIdTap()
        } else {
            passwordTextField.becomeFirstResponder()
        }
        
        return true
    }
    
    
}


