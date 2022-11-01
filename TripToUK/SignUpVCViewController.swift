//
//  SignUpVCViewController.swift
//  TripToUK
//
//  Created by Berk on 31.10.2022.
//

import UIKit
import FirebaseAuth

class SignUpVCViewController: UIViewController {

    @IBOutlet var usernameTextfiled: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var confirmPasswordTextfield: UITextField!
    @IBOutlet var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func registerButtonTapped(_ sender: Any) {
        
        if usernameTextfiled.text != nil && passwordTextfield.text != nil && confirmPasswordTextfield.text != nil && (passwordTextfield.text == confirmPasswordTextfield.text) {
            Auth.auth().createUser(withEmail: usernameTextfiled.text!, password: passwordTextfield.text!) { authdata, error in
                if error != nil {
                    self.showAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    let successAlert = UIAlertController(title: "Success", message: "New User Created", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default) { action in
                        self.dismiss(animated: true)
                    }
                    successAlert.addAction(okButton)
                    self.present(successAlert, animated: true)
                }
            }
        } else {
            showAlert(titleInput: "Error", messageInput: "Check Your Username/Password")
        }
        
    }
    
    func showAlert(titleInput: String, messageInput: String) {
        let ac = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        ac.addAction(okButton)
        present(ac, animated: true)
    }
    
}
