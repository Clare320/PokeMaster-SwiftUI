//
//  MainTab.swift
//  PokeMaster
//
//  Created by lingjie.li on 2021/5/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct MainTab: View {
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
    }
}

struct MainTab_Previews: PreviewProvider {
    static var previews: some View {
        MainTab()
    }
}
