//
//  ItemModel.swift
//  Todoey
//
//  Created by Ruslan Malinovsky on 24.04.2022.
//

import RealmSwift

class ItemModel {
    
    private let parentCategory: Category
    private let dataModelManager: DataModelManager<Item>
    
    private var items: Results<Item>?
    
    init(parentCategory: Category) {
        self.parentCategory = parentCategory
        self.dataModelManager = DataModelManager<Item>()
        
        loadAllItems()
    }
    
    var itemsCount: Int {
        return items?.count ?? 0
    }
    
    func getItem(at index: Int) -> Item? {
        return items?[index]
    }
    
    func inverseItemMark(at index: Int) {
        if let item = items?[index] {
            dataModelManager.update {
                item.done = !item.done
            }
        }
    }
    
    func loadAllItems() {
        items = parentCategory.items.sorted(byKeyPath: "title", ascending: true)
    }
    
    func appendItem(title: String) {
        let item = Item()
        item.title = title
        item.done = false
        item.dateCreated = Date()
        dataModelManager.create(item: item)
        
        dataModelManager.update {
            parentCategory.items.append(item)
        }
    }
    
    func removeItem(at index: Int) {
        if let item = items?[index] {
            dataModelManager.remove(item: item)
        }
    }
    
    func searchItems(searchText: String) {
        items = items?.filter(K.QueryFilters.containsTitle, searchText).sorted(byKeyPath: "dateCreated", ascending: true)
    }
}
