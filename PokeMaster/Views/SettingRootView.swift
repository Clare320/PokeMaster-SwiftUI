//
//  SettingRootView.swift
//  PokeMaster
//
//  Created by lingjie.li on 2021/5/21.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct SettingRootView: View {
    var body: some View {
        NavigationView {
            SettingView().navigationTitle("设置")
        }
    }
}

struct SettingRootView_Previews: PreviewProvider {
    static var previews: some View {
        SettingRootView()
    }
}
