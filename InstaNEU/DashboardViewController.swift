//
//  DashboardViewController.swift
//  InstaNEU
//
//  Created by Ashish Ashish on 3/31/20.
//  Copyright © 2020 Ashish Ashish. All rights reserved.
//

import UIKit
import Firebase

class DashboardViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            
            try firebaseAuth.signOut()
            KeyChainClass().key.clear()
            navigationController?.popViewController(animated: true)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
          
    }
    
    @IBAction func takePicture(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //imgView.contentMode = .scaleToFill
            imgView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
}
