//
//  ViewController.swift
//  Netflix Watchlist
//
//  Created by Vasco Meerman on 07/12/2016.
//  Copyright © 2016 Vasco Meerman. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
//            // 2
//            if user != nil {
//                // 3
//                self.performSegue(withIdentifier: "LoginToList", sender: nil)
//            }
//        }
//        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goTapped(_ sender: Any) {
        // Now it will login, regards inputted user is registered at firebase.
        FIRAuth.auth()!.signIn(withEmail: textFieldLoginEmail.text!,
                               password: textFieldLoginPassword.text!)
        self.performSegue(withIdentifier: "LoginToList", sender: nil)
        
        textFieldLoginEmail.text = ""
        textFieldLoginPassword.text = ""
    }
    
    
    @IBAction func registerTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
     
            let saveAction = UIAlertAction(title: "Save",
                                           style: .default) { action in
                                            
                if ( alert.textFields?[0].text != "" && alert.textFields?[1].text != "" ){
                    // 1
                    let emailField = alert.textFields![0]
                    let passwordField = alert.textFields![1]
                    
                    // 2
                    FIRAuth.auth()!.createUser(withEmail: emailField.text!,
                                               password: passwordField.text!) { user, error in
                        if error == nil {
                            // 3
                            FIRAuth.auth()!.signIn(withEmail: self.textFieldLoginEmail.text!,
                                                   password: self.textFieldLoginPassword.text!)
                            print("registration succesfull")
                        }
                        else{
                            print("registration failure error: \(error)")
                        }
                    }
                }
                else {
                    self.signupErrorAlert(title: "Oops!", message: "Don't forget to enter your email, password, and a username.")
                }
                    
            }
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .default)
            
            alert.addTextField { textEmail in
                textEmail.placeholder = "Enter your email"
            }
            
            alert.addTextField { textPassword in
                textPassword.isSecureTextEntry = true
                textPassword.placeholder = "Enter your password"
            }
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
         
    }
    
    func signupErrorAlert(title: String, message: String) {
        // Called upon signup error to let the user know signup didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    override func encodeRestorableState(with coder: NSCoder) {
        if let email = textFieldLoginEmail.text{
            coder.encode(email, forKey: "email")
        }
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        textFieldLoginEmail.text = coder.decodeObject(forKey: "email") as? String
        
        super.decodeRestorableState(with: coder)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == textFieldLoginEmail {
                textFieldLoginPassword.becomeFirstResponder()
            }
            if textField == textFieldLoginPassword {
                textField.resignFirstResponder()
            }
            return true
    }

}
