//
//  SettingView.swift
//  PokeMaster
//
//  Created by lingjie.li on 2021/5/21.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var settings = Settings()
    
    var accountSection: some View {
        Section(header: Text("账户")) {
            Picker(selection: $settings.accountBehavior, label: Text("Picker")) {
                ForEach(Settings.AccountBehavior.allCases, id: \.self) {
                    Text($0.text)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            TextField("电子邮箱", text: $settings.email)
            SecureField("密码", text: $settings.password)
            if settings.accountBehavior == .register {
                SecureField("确认密码", text: $settings.verifyPassword)
            }
            Button(settings.accountBehavior.text) {
                print("login/register")
            }
        }
    }
    
    var optionSection: some View {
        Section(header: Text("选项")) {
            Toggle("显示英文名", isOn: $settings.showEnglishName)
            Picker("排序方式", selection: $settings.sorting) {
                ForEach(Settings.Sorting.allCases, id: \.self) {
                    Text($0.text)
                }
            }
            Toggle("只显示收藏", isOn: $settings.showFavoriteOnly)
        }
    }
    
    var cacheSection: some View {
        Section {
            Button(action: {}, label: {
                Text("清空缓存")
                    .foregroundColor(.red)
            })
        }
    }

    var body: some View {
        Form {
            accountSection
            optionSection
            cacheSection
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
