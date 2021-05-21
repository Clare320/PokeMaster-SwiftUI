//
//  PokemonListRootView.swift
//  PokeMaster
//
//  Created by lingjie.li on 2021/5/21.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonListRootView: View {
    var body: some View {
        NavigationView {
            PokemonList()
                .navigationTitle("Pokemon")
        }
    }
}

struct PokemonListRootView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListRootView()
    }
}
