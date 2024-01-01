


import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        navigationItem.title = "Log In"
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        let email = emailTextfield.text!
        let password = passwordTextfield.text!
        if(email == "") {
            emailTextfield.placeholder = "Email shouldn't be empty"
            return
        }
        if(password == "") {
            passwordTextfield.placeholder = "password shouldn't be empty"
            return
        }
        
        
        Auth.auth().signIn(withEmail: email, password: password) { [unowned self] authResult, error in
            if error != nil {
              return
            }
            performSegue(withIdentifier:"loginToChart" , sender: self)
        }
        
    }
    
}
