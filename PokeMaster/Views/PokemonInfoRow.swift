//
//  PokemonInfoRow.swift
//  PokeMaster
//
//  Created by lingjie.li on 2021/5/20.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI
import Kingfisher

struct ToolButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 25))
            .foregroundColor(.white)
            .frame(width: 30, height: 30)
    }
}

struct PokemonInfoRow: View {
    @EnvironmentObject var store: Store
    
    let model: PokemonViewModel
    let expanded: Bool
    
    var body: some View {
        VStack {
            HStack {
                KFImage(model.iconImageURL)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 4)
                Spacer()
                VStack(alignment: .trailing) {
                    Text(model.name)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    Text(model.nameEN)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 12)
            HStack(spacing: expanded ? CGFloat(20.0) : -30.0) {
                Spacer()
                Button(action: {}, label: {
                    Image(systemName: "star")
                        .modifier(ToolButtonModifier())
                })
                Button(action: {
                    let target = !self.store.appState.pokemonList.selectionState.panelPresented
                    self.store.dispatch(.togglePanelPresenting(presenting: target))
                }, label: {
                    Image(systemName: "chart.bar")
                        .modifier(ToolButtonModifier())
                })
                Button(action: {}, label: {
                    Image(systemName: "info.circle")
                        .modifier(ToolButtonModifier())
                })
            }
            .padding(.bottom, 12)
            .opacity(expanded ? 1.0 : 0.0)
            .frame(maxHeight: expanded ? CGFloat.infinity : 0.0)
        }
        .frame(height: expanded ? CGFloat(120.0) : 80.0)
        .padding(.leading, 23)
        .padding(.trailing, 15)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(model.color, style: StrokeStyle(lineWidth: 4))
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.white, model.color]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
        )
        .padding(.horizontal)
//        .onTapGesture {
//            withAnimation {
//                expanded.toggle()
//            }
//        }
    }
}

struct PokemonInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        PokemonInfoRow(model: PokemonViewModel.sample(id: 1), expanded: false).previewLayout(.sizeThatFits)
        PokemonInfoRow(model: PokemonViewModel.sample(id: 21), expanded: true).previewLayout(.sizeThatFits)
        PokemonInfoRow(model: PokemonViewModel.sample(id: 25), expanded: false).previewLayout(.sizeThatFits)
    }
}
