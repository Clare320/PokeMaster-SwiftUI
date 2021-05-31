//
//  PokemonList.swift
//  PokeMaster
//
//  Created by lingjie on 2021/5/20.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonList: View {
    @State var searchText: String = ""
    @EnvironmentObject var store: Store
    var body: some View {
        // 如何隐藏掉分割线
//        List(PokemonViewModel.all) { pokemon in
//            PokemonInfoRow(model: pokemon, expanded: false)
//        }
        VStack {
            TextField("搜索", text: $searchText) { editing in
                
            } onCommit: {
                
            }
            .background(Color(.gray))
            .padding(.all, 12)
            ScrollView {
                LazyVStack {
                    ForEach(store.appState.pokemonList.allPokemonsByID) { pokemon in
                        PokemonInfoRow(model: pokemon, expanded: store.appState.pokemonList.expandingIndex == pokemon.id)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.55, dampingFraction: 0.425, blendDuration: 0)) {
                                    store.dispatch(.expandPokemonRow(id: pokemon.id))
                                }
                            }
                    }
                }
            }
        }
//        .overlay(
//            VStack {
//                Spacer()
//                PokemonPanel(model: .sample(id: 1))
//            }
//            .edgesIgnoringSafeArea(.bottom)
//        )
       
    }
}

struct PokemonList_Previews: PreviewProvider {
    static var previews: some View {
        PokemonList().environmentObject(Store())
    }
}


// ScollView顶部会遮挡元素
