//
//  CategoryItem.swift
//  Todoey
//
//  Created by Роман Цветков on 11.05.2020.
//  Copyright © 2020 Roman Tsvetkov. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryItem: Object {
    @objc dynamic var name: String = ""
    let items = List<ToDoItem>()
}
