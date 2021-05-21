//
//  BlurView.swift
//  PokeMaster
//
//  Created by lingjie.li on 2021/5/21.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import UIKit
import SwiftUI

struct BlurView: UIViewRepresentable {

    typealias UIViewType = UIView
    
    let style: UIBlurEffect.Style
    
    init(style: UIBlurEffect.Style) {
        print("blurView --- init")
        self.style = style
    }
        
    func makeUIView(context: Context) -> UIView {
        print("blurView---makeUIView")
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.tag = 1111
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.heightAnchor
                .constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor
                .constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        print("blurView---updateUIView")
        guard let blurView = uiView.viewWithTag(1111) as? UIVisualEffectView else {
            return
        }
        
        blurView.effect = UIBlurEffect(style: self.style)
    }
}

extension View {
    func blurBackground(style: UIBlurEffect.Style) -> some View {
        ZStack {
            BlurView(style: style)
            self
        }
    }
}
