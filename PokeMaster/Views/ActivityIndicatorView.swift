//
//  ActivityIndicatorView.swift
//  PokeMaster
//
//  Created by lingjie.li on 2021/5/25.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
    let animating: Bool
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let indicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        if animating {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
    
    typealias UIViewType = UIActivityIndicatorView

}
