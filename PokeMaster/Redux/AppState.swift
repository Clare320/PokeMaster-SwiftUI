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
    
    var pokemonList = PokemonList()
}

extension AppState {
    struct PokemonList {
        var pokemons: [Int: PokemonViewModel]?
        var loadingPokemons = false
        
        var allPokemonsByID: [PokemonViewModel] {
            guard let pokemons = pokemons?.values else {
                return [];
            }
            return pokemons.sorted { $0.id > $1.id }
        }
    }
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
            
            var isPasswordValid: AnyPublisher<Bool, Never> {
                Publishers.CombineLatest($password, $verifyPassword)
                    .flatMap { password, verifyPassword -> AnyPublisher<Bool, Never> in
                        let result = password.count > 0 && verifyPassword.count > 0 && password == verifyPassword
                        return Just(result).eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
        }
        
        @FileStorage(directory: .documentDirectory, fileName: "user.json")
        var loginUser: User?
        
        var loginRequesting = false
        var loginError: AppError?
        
        var accountChecker = AccountChecker()
        var isEmailValid = false
        var isPasswordValid = false
        
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
