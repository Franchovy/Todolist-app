//
//  TodoItem.swift
//  Todoey
//
//  Created by Maxime Franchot on 01/08/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct TodoItem: Codable {
    var title: String
    var done: Bool = false
}
