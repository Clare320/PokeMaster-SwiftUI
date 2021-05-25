//
//  UserDefaultsStorage.swift
//  PokeMaster
//
//  Created by lingjie.li on 2021/5/25.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefaultsStorage {
    var value: Bool
    
    let key: String
    
    init(key: String) {
        value = UserDefaults.standard.bool(forKey: key)
        self.key = key
    }
    
    var wrappedValue: Bool {
        set {
            if value == newValue {
                return
            }
            value = newValue
            UserDefaults.standard.set(value, forKey: key)
        }
        get { value }
    }
}


