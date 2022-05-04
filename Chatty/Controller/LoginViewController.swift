//
//  LoginViewController.swift
//  Chatty
//
//  Created by Spiky WU7 on 27.04.2022.
//

import Foundation
import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        //Firebase method for login
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
//              memory leak?
//              [weak self]
//              guard let strongSelf = self else { return }
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    //Navigate to chat vc
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }
        

        
    }
    
    
}
