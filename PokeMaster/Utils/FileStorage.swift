//
//  FileStorage.swift
//  PokeMaster
//
//  Created by lingjie.li on 2021/5/25.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

@propertyWrapper
struct FileStorage<T: Codable> {
    typealias PathDirectory = FileManager.SearchPathDirectory
    
    var value: T?
    
    let directory: PathDirectory
    let fileName: String
    
    init(directory: PathDirectory, fileName: String) {
        value = try? FileHelper.loadJSON(from: directory, fileName: fileName)
        self.directory = directory
        self.fileName = fileName
    }
    
    var wrappedValue: T? {
        set {
            value = newValue
            if let value = newValue {
                try? FileHelper.writeJSON(value, to: directory, fileName: fileName)
            } else {
                try? FileHelper.delete(from: directory, fileName: fileName)
            }
        }
        get { value }
    }
}

