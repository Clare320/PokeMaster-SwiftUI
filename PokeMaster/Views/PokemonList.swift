//
//  PokemonList.swift
//  PokeMaster
//
//  Created by lingjie on 2021/5/20.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonList: View {
    @EnvironmentObject var store: Store
    
    var pokemonList: AppState.PokemonList {
        store.appState.pokemonList
    }
    
    var body: some View {
        // 如何隐藏掉分割线
        //        List(PokemonViewModel.all) { pokemon in
        //            PokemonInfoRow(model: pokemon, expanded: false)
        //        }
        ScrollView {
            LazyVStack {
                TextField("搜索", text: $store.appState.pokemonList.searchText) { editing in
                    
                } onCommit: {
                    
                }
                .animation(nil)
                .frame(height: 40)
                .padding(.horizontal, 25)
                ForEach(store.appState.pokemonList.allPokemonsByID) { pokemon in
                    PokemonInfoRow(model: pokemon, expanded: self.pokemonList.selectionState.isExpanding(pokemon.id))
                        .onTapGesture {
                            withAnimation(.spring(response: 0.55, dampingFraction: 0.425, blendDuration: 0)) {
                                store.dispatch(.toggleListSelection(index: pokemon.id))
                            }
                            store.dispatch(.loadAbilities(pokemon: pokemon.pokemon))
                        }
                }
            }
        }
    }
    
}

struct PokemonList_Previews: PreviewProvider {
    static var previews: some View {
        PokemonList().environmentObject(Store())
    }
}


// ScollView顶部会遮挡元素
