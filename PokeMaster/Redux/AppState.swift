//
//  AppState.swift
//  PokeMaster
//
//  Created by lingjie.li on 2021/5/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation
import Combine

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
        
        class AccountChecker {
            @Published var accountBehavior = AccountBehavior.login
            @Published var email = ""
            @Published var password = ""
            @Published var verifyPassword = ""
            
            var isEmailVaild: AnyPublisher<Bool, Never> {
                let remoteVerify = $email
                    .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
                    .removeDuplicates()
                    .flatMap { email -> AnyPublisher<Bool, Never> in
                        let validEmail = email.isValidEmailAddress
                        let canSkip = self.accountBehavior == .login
                        
                        switch (validEmail, canSkip) {
                        case (false, _):
                            return Just(false).eraseToAnyPublisher()
                        case (true, false):
                            return EmailCheckingRequest(email: email)
                                .publisher
                                .eraseToAnyPublisher()
                        case (true, true):
                            return Just(true).eraseToAnyPublisher()
                        }
                    }
                let emailLocalValid = $email.map{ $0.isValidEmailAddress }
                let canSkipRemoteVerify = $accountBehavior.map { $0 == .login }
                return Publishers.CombineLatest3(remoteVerify, emailLocalValid, canSkipRemoteVerify)
                    .map { $0 && ($1 || $2) }
                    .eraseToAnyPublisher()
            }
        }
        
        @FileStorage(directory: .documentDirectory, fileName: "user.json")
        var loginUser: User?
        
        var loginRequesting = false
        var loginError: AppError?
        
        var accountChecker = AccountChecker()
        var isEmailValid = false
        
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
