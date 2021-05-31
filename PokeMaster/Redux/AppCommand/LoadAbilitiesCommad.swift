//
//  LoadAbilitiesCommad.swift
//  PokeMaster
//
//  Created by lingjie.li on 2021/5/31.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation
import Combine

struct LoadAbilitiesCommand: AppCommand {
    let pokemon: Pokemon
    
    func load(pokemonAbility: Pokemon.AbilityEntry, in store: Store)
        -> AnyPublisher<AbilityViewModel, AppError>
    {
        if let value = store.appState.pokemonList.abilities?[pokemonAbility.id.extractedID!] {
            return Just(value)
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
        } else {
            return LoadAbilityRequest(pokemonAbility: pokemonAbility).publisher
        }
    }

    func execute(in store: Store) {
        let token = SubscriptionToken()
        pokemon.abilities
            .map { load(pokemonAbility: $0, in: store) }
            .zipAll
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.loadAbilitiesDone(result: .failure(error)))
                    }
                    token.unseal()
                },
                receiveValue: { value in
                    store.dispatch(.loadAbilitiesDone(result: .success(value)))
                }
            )
            .seal(in: token)
    }
}
