//
//  LoginRequest.swift
//  PokeMaster
//
//  Created by lingjie.li on 2021/5/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation
import Combine

struct LoginRequest {
    let email: String
    let password: String
    
    var publisher: AnyPublisher<User, AppError> {
        Future { promise in
            DispatchQueue.global()
                .asyncAfter(deadline: .now() + 1.5) {
                    if password == "123" {
                        let user = User(email: email, favioritePokemonIDs: [])
                        promise(.success(user))
                    } else {
                        promise(.failure(.passwordWrong))
                    }
                }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
