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
    
    // MARK: - OUTLETS
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Login to SnappyChatty"
        
        emailTextField.becomeFirstResponder()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: - HELPER METHODS
    func showAlert(title: String, message: String, buttonTitle: String) {
        GeneralHelper.sharedHelper.showAlertOnViewController(viewController: self, withTitle: title, message: message, buttonTitle: buttonTitle)
    }

    // MARK: - ACTIONS
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
        }
    }
    
    @IBAction func actionBackDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UITextFieldDelegate
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


