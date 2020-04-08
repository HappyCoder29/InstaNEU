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
import SwiftSpinner

class RegisterViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var txtReenter: UITextField!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()

        lblStatus.isHidden = true
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        let email = txtEmail.text!
        let password = txtPassword.text!
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
        
        SwiftSpinner.show("Creating User", animated: true)
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            SwiftSpinner.hide()
            if error != nil {
                self.lblStatus.isHidden = false
                self.lblStatus.text = error?.localizedDescription
                return
            }
            guard let user = authResult?.user else {
                self.navigationController?.popViewController(animated: true)
                return
            }
            self.updateProfile(user)
        }
        
    }
    
    
    func updateProfile(_ user : User){
        
        let uid = user.uid
        
        let ref = Storage.storage().reference().child("Profile").child(uid).child("ProfileImage.png")
        
        if let uploadData = imgView.image?.jpegData(compressionQuality: 0.1){
            
            SwiftSpinner.show("Uploading Profile Image", animated: true)
            ref.putData(uploadData, metadata: nil) { (metadata, error) in
                SwiftSpinner.hide()
                guard let metadata = metadata else {return}
                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                print(size)
                // You can also access to download URL after upload.
                ref.downloadURL { (url, error) in
                    guard let downloadURL = url else {return}
                    self.updateUserProfile(user: user, url: downloadURL)
                }
            }
        }
    }
    
    func updateUserProfile(user: User,  url : URL){
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = txtName.text
        changeRequest.photoURL = url
        changeRequest.commitChanges { (error) in
            if error != nil{
                print("Error in updationg profile")
                return
            }
            self.updateDB(url, user)
        }
    }
    func updateDB(_ url: URL, _ user: User){
        
        let uid = user.uid
        db.collection("users").document(uid).setData([
            "name": txtName.text!,
            "email": txtEmail.text!,
            "url": url.absoluteString,
            "isPublic": true
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
            self.updateFollowers(url, uid)
        }
        
    }
    
    func updateFollowers(_ url: URL, _ uid: String){
        db.collection("UserData").document(uid).collection("Followers").addDocument(data: [
        "name":  txtName.text!,
        "uid": uid
        ]  ){
            err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
            self.updateFollowing(uid)
            
        }
    }
    
    func updateFollowing(_ uid: String){
        db.collection("UserData").document(uid).collection("Following").addDocument(data: [
            "name":  txtName.text!,
            "uid": uid
            ]){
            err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
            self.navigationController?.popViewController(animated: true);
        }
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //imgView.contentMode = .scaleToFill
            imgView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func takePic(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    
    
}
