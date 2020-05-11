//
//  ToDoItem.swift
//  Todoey
//
//  Created by Роман Цветков on 11.05.2020.
//  Copyright © 2020 Roman Tsvetkov. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: CategoryItem.self, property: "items")
}
