import Foundation
import UIKit
import Firebase

final class LoginViewController: UIViewController {
    
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    
    @IBAction private func loginButtonPressed() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard error == nil else { return }
            self.performSegue(withIdentifier: K.loginSegue, sender: self)
        }
    }
}
