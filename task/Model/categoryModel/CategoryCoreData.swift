//
//  CategoryCoreData.swift
//  task
//
//  Created by islam on 9/24/20.
//

import Foundation
import CoreData
import RxDataSources
import RxCoreData


struct CategoryCoreData {
    var id: String
    var name: String
    
    init(category: Category) {
        self.id = category.id!
        self.name = category.name!
    }
    
}

func == (lhs: CategoryCoreData, rhs: CategoryCoreData) -> Bool {
    return lhs.id == rhs.id
}

extension CategoryCoreData : Equatable { }

extension CategoryCoreData : IdentifiableType {
    typealias Identity = String
    
    var identity: Identity { return "\(id)" }
}

extension CategoryCoreData : Persistable {
    typealias T = NSManagedObject
    
    static var entityName: String {
        return "Categories"
    }
    
    static var primaryAttributeName: String {
        return "id"
    }
    
    init(entity: T) {
        id = entity.value(forKey: "id") as! String
        name = entity.value(forKey: "name") as! String

    }
    
    func update(_ entity: T) {
        entity.setValue(id, forKey: "id")
        entity.setValue(name, forKey: "name")
        do {
            try entity.managedObjectContext?.save()
        } catch let e {
            print(e)
        }
    }
    
}
