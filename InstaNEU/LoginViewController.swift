//
//  ViewController.swift
//  InstaNEU
//
//  Created by Ashish Ashish on 3/31/20.
//  Copyright © 2020 Ashish Ashish. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStatus.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let keychain = KeyChainClass().key
        
        if keychain.get("uid") != nil {
            performSegue(withIdentifier: "segueLogin", sender: self)
        }
    }
    
    
    @IBAction func loginPressed(_ sender: Any) {
        
        let email = txtEmail.text!
        let password = txtPassword.text!
        
        if(email.count < 5){
            lblStatus.isHidden = false;
            lblStatus.text = "Please enter valid Email"
            return
        }
        
        if password.count < 6 {
            lblStatus.isHidden = false;
                       lblStatus.text = "Please enter valid password"
                       return
        }
        
        if !email.isEmail {
            lblStatus.isHidden = false;
            lblStatus.text = "Please enter valid email"
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) {
            [weak self] authResult, error in
            
            guard let strongSelf = self else { return }

            
            if error != nil {
                strongSelf.lblStatus.isHidden = false
                strongSelf.lblStatus.text = error?.localizedDescription
                return
            }
            
            // go to a Logged in controller
            print("Successfully Logged in")
            let uid = Auth.auth().currentUser!.uid
            KeyChainClass().key.set(uid, forKey:"uid")
            
            strongSelf.performSegue(withIdentifier: "segueLogin", sender: strongSelf)
        }
        
    
    }
    

}

extension String {
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}


