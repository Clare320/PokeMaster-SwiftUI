//
//  PokemonPanel.swift
//  PokeMaster
//
//  Created by lingjie.li on 2021/5/21.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonPanel: View {
    @State var darkBlur = false
    
    let model: PokemonViewModel
    var abilities: [AbilityViewModel] {
        AbilityViewModel.sample(pokemonID: model.id)
    }
    
    var topIndicator: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(width: 40, height: 6)
            .opacity(0.2)
    }
    
    var pokemonDescription: some View {
        Text(model.descriptionText)
            .font(.callout)
            .foregroundColor(Color(hex: 0x666666))
            .fixedSize(horizontal: false, vertical: true)
        // .lineLimit(2) 限制显示两行，用...显示
    }
    
    var body: some View {
        VStack(spacing: 20) {
            topIndicator
            Button("change") {
                darkBlur.toggle()
            }
            Header(model: model)
            pokemonDescription
            Divider()
            AbilityList(model: model, abilityModels: abilities)
        }
        .padding(EdgeInsets(top: 12, leading: 30, bottom: 30, trailing: 30))
        .blurBackground(style: darkBlur ? .systemMaterialDark : .systemMaterial)
        .cornerRadius(20)
        .fixedSize(horizontal: false, vertical: true)
    }
}

extension PokemonPanel {
    struct AbilityList: View {
        let model: PokemonViewModel
        let abilityModels: [AbilityViewModel]?
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text("技能")
                    .font(.headline)
                    .fontWeight(.bold)
                if abilityModels != nil {
                    ForEach(abilityModels!) { ability in
                        Text(ability.name)
                            .font(.subheadline)
                            .foregroundColor(model.color)
                        Text(ability.descriptionText)
                            .font(.footnote)
                            .foregroundColor(Color(hex: 0xAAAAAA))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }
}

extension PokemonPanel {
    // 为了更好地使用上下文
    struct Header: View {
        let model: PokemonViewModel
        
        var pokemonIcon: some View {
            Image("Pokemon-\(model.id)")
                .resizable()
                .frame(width: 68, height: 68)
        }
        
        var nameSpecies: some View {
            VStack(spacing: 10) {
                VStack {
                    Text(model.genus)
                        .fontWeight(.bold)
                        .font(.system(size: 22))
                    Text(model.genusEN)
                        .fontWeight(.bold)
                        .font(.system(size: 13))
                }
                .foregroundColor(model.color)
                Text(model.genus)
            }
        }
        
        var verticalDivider: some View {
            Rectangle()
                .frame(width: 1, height: 44)
                .background(Color(.black))
                .opacity(0.1)
        }
        
        var bodyStatus: some View {
            VStack {
                HStack {
                    Text("身高")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                    Text(model.height)
                        .foregroundColor(model.color)
                }
                HStack {
                    Text("体重")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                    Text(model.weight)
                        .foregroundColor(model.color)
                }
                .padding(.bottom, 12)
            }
        }
        
        var typeInfo: some View {
            HStack {
                ForEach(model.types) { type in
                    Text(type.name)
                        .font(.system(size: 11))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 14)
                        .padding(EdgeInsets(top: 3, leading: 5, bottom: 3, trailing: 5))
                        .cornerRadius(7.0)
                        .background(type.color)
                }
            }
        }
        
        var body: some View {
            HStack(spacing: 18) {
                pokemonIcon
                nameSpecies
                verticalDivider
                VStack {
                    bodyStatus
                    typeInfo
                }
            }
        }
    }
}

struct PokemonPanel_Previews: PreviewProvider {
    static var previews: some View {
        PokemonPanel(model: PokemonViewModel.sample(id: 1))
    }
}
