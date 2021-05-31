//
//  MainTab.swift
//  PokeMaster
//
//  Created by lingjie.li on 2021/5/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct MainTab: View {
    
    @EnvironmentObject var store: Store

    private var pokemonList: AppState.PokemonList {
        store.appState.pokemonList
    }
    private var pokemonListBinding: Binding<AppState.PokemonList> {
        $store.appState.pokemonList
    }

    private var selectedPanelIndex: Int? {
        pokemonList.selectionState.panelIndex
    }
    
    var body: some View {
        TabView {
            PokemonListRootView()
                .tabItem {
                    Image(systemName: "list.bullet.below.rectangle")
                    Text("列表")
                }
            SettingView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("设置")
                }
        }
        .edgesIgnoringSafeArea(.top)
        .overlaySheet(isPresented: pokemonListBinding.selectionState.panelPresented) {
            if self.selectedPanelIndex != nil && self.pokemonList.pokemons != nil {
                PokemonPanel(
                    model: self.pokemonList.pokemons![self.selectedPanelIndex!]!
                )
            }
        }
    }
}

struct MainTab_Previews: PreviewProvider {
    static var previews: some View {
        MainTab()
    }
}
