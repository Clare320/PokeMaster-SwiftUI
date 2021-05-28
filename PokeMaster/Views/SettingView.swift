//
//  SettingView.swift
//  PokeMaster
//
//  Created by lingjie.li on 2021/5/21.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var store: Store
    
    var settingsBinding: Binding<AppState.Settings> {
        $store.appState.settings
    }
    
    var settings: AppState.Settings {
        store.appState.settings
    }
  
    var isCanRegister: Bool {
        store.appState.settings.isEmailValid && store.appState.settings.isPasswordValid
    }
    
    var accountSection: some View {
        Section(header: Text("账户")) {
            if settings.loginUser == nil {
                Picker(selection: settingsBinding.accountChecker.accountBehavior, label: Text("Picker")) {
                    ForEach(AppState.Settings.AccountBehavior.allCases, id: \.self) {
                        Text($0.text)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                TextField("电子邮箱", text: settingsBinding.accountChecker.email)
                    .foregroundColor(settings.isEmailValid ? .green : .red)
                SecureField("密码", text: settingsBinding.accountChecker.password)
                if settings.accountChecker.accountBehavior == .register {
                    SecureField("确认密码", text: settingsBinding.accountChecker.verifyPassword)
                }
                if settings.loginRequesting {
                    ActivityIndicatorView(animating: true)
                } else {
                    let disabled = settings.accountChecker.accountBehavior == .login
                        ? false : !(settingsBinding.isEmailValid.wrappedValue && settingsBinding.isPasswordValid.wrappedValue)
                    Button(settings.accountChecker.accountBehavior.text) {
                        if settings.accountChecker.accountBehavior == .login {
                            store.dispatch(.login(email: settings.accountChecker.email, password: settings.accountChecker.password))
                        } else {
                            store.dispatch(.register(email: settings.accountChecker.email, password: settings.accountChecker.password))
                        }
                    }
                    .disabled(disabled)
                }
            } else {
                Text(settings.loginUser!.email)
                Button("注销") {
                    store.dispatch(.logout)
                }
            }
        }
    }
    
    var optionSection: some View {
        Section(header: Text("选项")) {
            Toggle("显示英文名", isOn: settingsBinding.showEnglishName)
            Picker("排序方式", selection: settingsBinding.sorting) {
                ForEach(AppState.Settings.Sorting.allCases, id: \.self) {
                    Text($0.text)
                }
            }
            Toggle("只显示收藏", isOn: settingsBinding.showFavoriteOnly)
        }
    }
    
    var cacheSection: some View {
        Section {
            Button(action: {
                store.dispatch(.cleanCache)
            }, label: {
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
        .alert(item: settingsBinding.loginError) { error in
            Alert(title: Text(error.localizedDescription))
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView().environmentObject(Store())
    }
}

extension AppState.Settings.Sorting {
    var text: String {
        switch self {
        case .id:
            return "ID"
        case .color: return "颜色"
        case .name: return "名字"
        case .favorite: return "最爱"
        
        }
    }
}

extension AppState.Settings.AccountBehavior {
    var text: String {
        switch self {
        case .register:
            return "注册"
        case .login:
            return "登录"
        }
    }
}
