//
//  PokemonList.swift
//  PokeMaster
//
//  Created by lingjie on 2021/5/20.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonList: View {
    @State var expandingIndex: Int?
    
    var body: some View {
        // 如何隐藏掉分割线
//        List(PokemonViewModel.all) { pokemon in
//            PokemonInfoRow(model: pokemon, expanded: false)
//        }
        ScrollView {
            LazyVStack {
                ForEach(PokemonViewModel.all) { pokemon in
                    PokemonInfoRow(model: pokemon, expanded: expandingIndex == pokemon.id)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.55, dampingFraction: 0.425, blendDuration: 0)) {
                                if (expandingIndex == pokemon.id) {
                                    expandingIndex = nil
                                } else {
                                    expandingIndex = pokemon.id
                                }
                            }
                        }
                }
            }
        }
       
    }
}

struct PokemonList_Previews: PreviewProvider {
    static var previews: some View {
        PokemonList()
    }
}