//
//  ProductCoreDateModel.swift
//  task
//
//  Created by islam on 9/24/20.
//

import Foundation
import CoreData
import RxDataSources
import RxCoreData


struct ProductCoreDateModel {
    var id : String
    var name : String
    var categoryId : String
    var image : String
    var price : Int32
    
    init(product: Product) {
        self.id = product.id ?? ""
        self.name = product.name ?? ""
        self.price = Int32(product.price ?? 0)
        self.image = product.image ?? ""
        self.categoryId = product.category?.id ?? ""
    }
    
}

func == (lhs: ProductCoreDateModel, rhs: ProductCoreDateModel) -> Bool {
    return lhs.id == rhs.id
}

extension ProductCoreDateModel : Equatable { }

extension ProductCoreDateModel : IdentifiableType {
    typealias Identity = String
    
    var identity: Identity { return "\(id)" }
}

extension ProductCoreDateModel : Persistable {
    typealias T = NSManagedObject
    
    static var entityName: String {
        return "Products"
    }
    
    static var primaryAttributeName: String {
        return "id"
    }
    
    init(entity: T) {
        id = entity.value(forKey: "id") as! String
        name = entity.value(forKey: "name") as! String
        categoryId = entity.value(forKey: "categoryId") as! String
        image = entity.value(forKey: "image") as! String
        price = entity.value(forKey: "price") as! Int32
    }
    
    func update(_ entity: T) {
        entity.setValue(id, forKey: "id")
        entity.setValue(name, forKey: "name")
        entity.setValue(categoryId, forKey: "categoryId")
        entity.setValue(image, forKey: "image")
        entity.setValue(price, forKey: "price")
        do {
            try entity.managedObjectContext?.save()
        } catch let e {
            print(e)
        }
    }
    
}
