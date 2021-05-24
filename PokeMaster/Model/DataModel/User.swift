//
//  User.swift
//  PokeMaster
//
//  Created by lingjie.li on 2021/5/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

struct User: Codable {
    var email: String
    
    var favioritePokemonIDs: Set<Int>
    
    func isFavioritePokemon(id: Int) -> Bool {
        favioritePokemonIDs.contains(id)
    }
}
