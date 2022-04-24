//
//  Item.swift
//  Todoey
//
//  Created by Ruslan Malinovsky on 24.04.2022.
//

import RealmSwift
import UIKit

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

extension Item {
    var cellType: UITableViewCell.AccessoryType {
        return done ? .checkmark : .none
    }
}
