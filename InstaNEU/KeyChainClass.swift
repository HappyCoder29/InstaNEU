//
//  KeyChainClass.swift
//  InstaNEU
//
//  Created by Ashish Ashish on 3/31/20.
//  Copyright © 2020 Ashish Ashish. All rights reserved.
//

import Foundation
import KeychainSwift

class KeyChainClass{
    var _key = KeychainSwift()
    
    var key : KeychainSwift {
        get { return _key}
        set { _key = newValue}
    }
}
