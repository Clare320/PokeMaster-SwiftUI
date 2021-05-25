//
//  AppState.swift
//  PokeMaster
//
//  Created by lingjie.li on 2021/5/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

struct AppState {
    var settings = Settings()
    
    
}

extension AppState {
    struct Settings {
        enum Sorting: CaseIterable {
            case id, name, color, favorite
        }
        
        enum AccountBehavior: CaseIterable {
            case login, register
        }
        
        @FileStorage(directory: .documentDirectory, fileName: "user.json")
        var loginUser: User?
        
        var loginRequesting = false
        var loginError: AppError?
        
        var accountBehavior = AccountBehavior.login
        var email = ""
        var password = ""
        var verifyPassword = ""
        
        @UserDefaultsStorage(key: "showEnglishName")
        var showEnglishName: Bool {
            didSet {
                print("showEnglishName----\(showEnglishName)")
            }
        }
        
        var sorting = Sorting.id
        var showFavoriteOnly = false
    }
}
