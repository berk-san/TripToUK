//
//  ViewController.swift
//  TripToUK
//
//  Created by Berk on 31.10.2022.
//

import UIKit
import FirebaseAuth

class SignInVC: UIViewController {
    @IBOutlet var usernameText: UITextField!
    
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        if usernameText.text != nil && passwordText.text != nil {
            
            Auth.auth().signIn(withEmail: usernameText.text!, password: passwordText.text!) { authdata, error in
                if error != nil {
                    self.showAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    print("Welcome \(String(describing: authdata?.user.email))")
                    self.performSegue(withIdentifier: "toMainPageVC", sender: nil)
                }
            }
        } else {
            showAlert(titleInput: "Error", messageInput: "Username/Password can't be null")
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "toSignUpVC", sender: nil)
        
    }
    
    func showAlert(titleInput: String, messageInput: String) {
        let ac = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        ac.addAction(okButton)
        self.present(ac, animated: true)
    }
}

