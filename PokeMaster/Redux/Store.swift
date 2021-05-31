//
//  Store.swift
//  PokeMaster
//
//  Created by lingjie.li on 2021/5/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Combine

class Store: ObservableObject {
    init() {
        setupObservers()
    }
    
    var disposeBag = [AnyCancellable]()
    
    @Published var appState = AppState()
    
    func setupObservers() {
        appState.settings.accountChecker.isEmailVaild
            .sink { [self] valid in
                self.dispatch(.emailValid(valid: valid))
            }
            .store(in: &disposeBag)
        
        appState.settings.accountChecker.isPasswordValid
            .sink { valid in
                self.dispatch(.passwordValid(valid: valid))
            }
            .store(in: &disposeBag)
    }
    
    static func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand?
        
        switch action {
        case .login(let email, let password):
            guard !appState.settings.loginRequesting else {
                break
            }
            appState.settings.loginRequesting = true
            appCommand = LoginAppCommand(email: email, password: password)
        case .accountBehaviorDone(let result):
            appState.settings.loginRequesting = false
            switch result {
            case .success(let user):
                appState.settings.loginUser = user
            case .failure(let error):
                appState.settings.loginError = error
            }
        case .logout:
            appState.settings.loginUser = nil
            appState.settings.accountChecker.email = ""
            appState.settings.accountChecker.password = ""
        case .emailValid(let valid):
            appState.settings.isEmailValid = valid
        case .loadPokemons:
            if appState.pokemonList.loadingPokemons == true {
                break
            }
            appState.pokemonList.loadingPokemons = true
            appCommand = LoadPokemonsCommands()
        case .loadPokemonsDone(let result):
            switch result {
            case .success(let models):
                appState.pokemonList.pokemons = Dictionary(uniqueKeysWithValues: models.map { ($0.id, $0) })
            case .failure(let error):
                print("loadPokemonsDone-->\(error)")
            }
        case .passwordValid(let valid):
            appState.settings.isPasswordValid = valid
        case .register(let email, let password):
            appCommand = RegisterAppCommand(email: email, password: password)
        case .cleanCache:
            appState.settings.loginUser = nil
            appState.settings.accountChecker.email = ""
            appState.settings.accountChecker.password = ""
        case .expandPokemonRow(let id):
            if appState.pokemonList.expandingIndex == id {
                appState.pokemonList.expandingIndex = nil
            } else {
                appState.pokemonList.expandingIndex = id
            }
        }
        
        return (appState, appCommand)
    }
    
    func dispatch(_ action: AppAction) {
        #if DEBUG
            print("[ACTION]: \(action)")
        #endif
        let result = Store.reduce(state: appState, action: action)
        appState = result.0
        if let command = result.1 {
            #if DEBUG
                print("[COMMAND]")
            #endif
            command.execute(in: self)
        }
    }
    
}
