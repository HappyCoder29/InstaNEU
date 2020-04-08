//
//  UserModel.swift
//  InstaNEU
//
//  Created by Ashish Ashish on 4/7/20.
//  Copyright © 2020 Ashish Ashish. All rights reserved.
//

import Foundation

class UserModel{
    
    var name : String = ""
    var email: String = ""
    var url : URL?
    var isPublic : Bool = true
    
    init(_ name: String, _ email: String, _ url: URL, _ isPublic: Bool) {
        self.name = name
        self.email = email
        self.url = url
        self.isPublic = isPublic
    }
}
