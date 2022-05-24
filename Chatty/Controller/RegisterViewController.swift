import Foundation
import UIKit
import Firebase

final class RegisterViewController: UIViewController {
    
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    
    @IBAction private func registerButtonPressed() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard error == nil else { return }
            self.performSegue(withIdentifier: K.registerSegue, sender: self)
        }
    }
}

