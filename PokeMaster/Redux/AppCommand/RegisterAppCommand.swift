//
//  RegisterAppCommand.swift
//  PokeMaster
//
//  Created by lingjie.li on 2021/5/28.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

struct RegisterAppCommand: AppCommand {
    let email: String
    let password: String
    
    func execute(in store: Store) {
        let user = User(email: email, favioritePokemonIDs: [])
        store.dispatch(.accountBehaviorDone(result: .success(user)))
    }
}
