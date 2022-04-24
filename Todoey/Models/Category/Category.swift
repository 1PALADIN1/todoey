//
//  Category.swift
//  Todoey
//
//  Created by Ruslan Malinovsky on 24.04.2022.
//

import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var hexColor: String = ""
    
    let items = List<Item>()
}
