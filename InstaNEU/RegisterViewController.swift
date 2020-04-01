//
//  RegisterViewController.swift
//  InstaNEU
//
//  Created by Ashish Ashish on 3/31/20.
//  Copyright © 2020 Ashish Ashish. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtrPassword: UITextField!
    
    @IBOutlet weak var txtReenter: UITextField!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblStatus.isHidden = true
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        let email = txtEmail.text!
        let password = txtrPassword.text!
        let reenter = txtReenter.text!
        
        if email.count < 5 || !email.isEmail {
            lblStatus.isHidden = false
            lblStatus.text = "Please enter valiud e mail "
            return
        }
        
        if password.count < 6 {
            lblStatus.isHidden = false
            lblStatus.text = "Password is greater than 6 "
            return
        }
        
        if password != reenter {
            lblStatus.isHidden = false
            lblStatus.text = "Passwords dont match"
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if error != nil {
                self.lblStatus.isHidden = false
                self.lblStatus.text = error?.localizedDescription
                return
            }
            
            print("Successfully created user")
            self.navigationController?.popViewController(animated: true)

        }
        
    }
    
}
