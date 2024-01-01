

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    override func viewDidLoad() {
        navigationItem.title = "Register"
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
       
            if(emailTextfield.text == "") {
                emailTextfield.placeholder = "Email shouldn't be empty"
                return
            }
            if(passwordTextfield.text == "") {
                passwordTextfield.placeholder = "password shouldn't be empty"
                return
            }
            
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) {[unowned self]
            authResult, error in
            if let error = error {
                print(error)
                return
            }
            performSegue(withIdentifier: "registerToChart", sender: self)
            
        }
    }
    
}
