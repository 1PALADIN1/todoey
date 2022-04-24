//
//  CategoryModel.swift
//  Todoey
//
//  Created by Ruslan Malinovsky on 24.04.2022.
//

import RealmSwift
import ChameleonFramework

class CategoryModel {
    private let dataModelManager = DataModelManager<Category>()
    private var categories: Results<Category>?
    
    var categoryItemsCount: Int {
        return categories?.count ?? 0
    }
    
    func getCategory(at index: Int) -> Category? {
        return categories?[index]
    }
    
    func removeCategory(at index: Int) {
        if let category = categories?[index] {
            dataModelManager.remove(item: category)
        }
    }
    
    func loadAllCategories() {
        categories = dataModelManager.load()
    }
    
    func appendCategory(name: String) {
        dataModelManager.create { category in
            category.name = name
            category.hexColor = UIColor.randomFlat().hexValue()
        }
    }
}
