//
//  AppError.swift
//  PokeMaster
//
//  Created by lingjie.li on 2021/5/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

enum AppError: Error, Identifiable {
    var id: String { localizedDescription }
    
    case passwordWrong
    case networkingFailed(Error)
}

extension AppError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .passwordWrong: return "密码错误"
        case .networkingFailed(let error):
            return error.localizedDescription
        }
    }
}
