//
//  SearchUsersTableViewController.swift
//  InstaNEU
//
//  Created by Ashish Ashish on 4/7/20.
//  Copyright © 2020 Ashish Ashish. All rights reserved.
//

import UIKit
import Firebase

class SearchUsersTableViewController: UITableViewController, UISearchBarDelegate {

    var db: Firestore!
    
    @IBOutlet weak var srchBar: UISearchBar!
    @IBOutlet var tblView: UITableView!
    
    
    var arr = [UserModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.delegate = self
        tblView.dataSource = self
        srchBar.delegate = self
        db = Firestore.firestore()
        
        getAllUsers()
    }
    
    func getAllUsers(){
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    let uid = Auth.auth().currentUser?.uid
                    
                    if uid == document.documentID {
                        continue
                    }
                    
                    let userData: [String: Any] = document.data()
                
                    guard let name = userData["name"] as? String else {return }
                    guard let email = userData["email"] as? String else {return }
                    guard let url = userData["url"] as? String else {return }
                    guard let isPublic = userData["isPublic"] as? Bool else {return }
                    
                    let user = UserModel(name, email, URL(string: url)!, isPublic)
                    
                    self.arr.append(user)
                    print(user)
                }
                self.tblView.reloadData()
                
            }
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let name = arr[indexPath.row].name
        let email = arr[indexPath.row].email

        cell.textLabel?.text = String("\(name) : \(email)")

        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           
//           guard !searchBar.text!.isEmpty else {
//              // arr = search
//               tableView.reloadData()
//               return
//           }
        print(searchText)
           
//           arr = search.filter({ (stock) -> Bool in
//               stock.symbol.lowercased().contains(searchText.lowercased())
//           })
//           tableView.reloadData()
       }
    

}
