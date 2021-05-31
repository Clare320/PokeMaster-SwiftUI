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
        
        var abilities: [Int: AbilityViewModel]?
        
        struct SelectionState {
            var expandingIndex: Int? = nil
            var panelIndex: Int? = nil
            var panelPresented = false
            var radarProgress: Double = 0
            var radarShouldAnimate = true

            func isExpanding(_ id: Int) -> Bool {
                expandingIndex == id
            }
        }
        var selectionState = SelectionState()
        
        var searchText: String = ""
        
        var expandingIndex: Int?
        
        var allPokemonsByID: [PokemonViewModel] {
            guard let pokemons = pokemons?.values else {
                return [];
            }
            return pokemons.sorted { $0.id > $1.id }
        }
        
        func abilityViewModels(for pokemon: Pokemon) -> [AbilityViewModel]? {
            return nil
        }
        
        func displayPokemons(with settings: Settings) -> [PokemonViewModel] {

            func isFavorite(_ pokemon: PokemonViewModel) -> Bool {
                guard let user = settings.loginUser else { return false }
                return user.isFavoritePokemon(id: pokemon.id)
            }

            func containsSearchText(_ pokemon: PokemonViewModel) -> Bool {
                guard !searchText.isEmpty else {
                    return true
                }
                return pokemon.name.contains(searchText) ||
                       pokemon.nameEN.lowercased().contains(searchText.lowercased())
            }

            guard let pokemons = pokemons else {
                return []
            }

            let sortFunc: (PokemonViewModel, PokemonViewModel) -> Bool
            switch settings.sorting {
            case .id:
                sortFunc = { $0.id < $1.id }
            case .name:
                sortFunc = { $0.nameEN < $1.nameEN }
            case .color:
                sortFunc = {
                    $0.species.color.name.rawValue < $1.species.color.name.rawValue
                }
            case .favorite:
                sortFunc = { p1, p2 in
                    switch (isFavorite(p1), isFavorite(p2)) {
                    case (true, true): return p1.id < p2.id
                    case (false, false): return p1.id < p2.id
                    case (true, false): return true
                    case (false, true): return false
                    }
                }
            }

            var filterFuncs: [(PokemonViewModel) -> Bool] = []
            filterFuncs.append(containsSearchText)
            if settings.showFavoriteOnly {
                filterFuncs.append(isFavorite)
            }

            let filterFunc = filterFuncs.reduce({ _ in true}) { r, next in
                return { pokemon in
                    r(pokemon) && next(pokemon)
                }
            }

            return pokemons.values
                .filter(filterFunc)
                .sorted(by: sortFunc)
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
