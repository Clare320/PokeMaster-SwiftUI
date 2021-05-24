//
//  AppCommand.swift
//  PokeMaster
//
//  Created by lingjie.li on 2021/5/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

protocol AppCommand {
    func execute(in store: Store)
}
