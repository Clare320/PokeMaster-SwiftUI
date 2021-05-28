//
//  LoadPokemonsCommand.swift
//  PokeMaster
//
//  Created by lingjie.li on 2021/5/28.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

struct LoadPokemonsCommands: AppCommand {
    func execute(in store: Store) {
        let token = SubscriptionToken()
        LoadPokemonRequest.all
            .sink { complete in
                if case .failure(let error) = complete {
                    store.dispatch(.loadPokemonsDone(result: .failure(error)))
                }
                token.unseal()
            } receiveValue: { value in
                store.dispatch(.loadPokemonsDone(result: .success(value)))
            }
            .seal(in: token)
    }
}
