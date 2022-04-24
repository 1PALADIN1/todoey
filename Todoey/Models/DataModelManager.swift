//
//  DataModelManager.swift
//  Todoey
//
//  Created by Ruslan Malinovsky on 24.04.2022.
//

import RealmSwift

struct DataModelManager<T: Object> {
    
    private let realm = try! Realm()
    
    func create(item: T) {
        do {
            try realm.write({
                realm.add(item)
            })
        } catch {
            fatalError("Error creating: \(error.localizedDescription)")
        }
    }
    
    func create(with callback: (T) -> Void) {
        let item = T()
        callback(item)
        create(item: item)
    }
    
    func remove(item: T) {
        
        do {
            try realm.write({
                realm.delete(item)
            })
        } catch {
            fatalError("Error removing: \(error.localizedDescription)")
        }
    }
    
    func update(context: () -> Void) {
        do {
            try realm.write {
                context()
            }
        } catch {
            fatalError("Error updating: \(error.localizedDescription)")
        }
    }
    
    func load() -> Results<T> {
        return realm.objects(T.self)
    }
}
