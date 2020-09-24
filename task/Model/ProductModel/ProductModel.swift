//
//  ProductModel.swift
//  task
//
//  Created by islam on 9/24/20.
//

import Foundation

class Product: Codable {
    var id : String?
    var name : String?
    var category : Category?
    var image : String?
    var price : Int?
    
    init(product: ProductCoreDateModel) {
        self.id = product.id
        self.name = product.name
        self.price = Int(product.price)
        self.image = product.image
        let _category = Category()
        _category.id = product.categoryId
        self.category = _category
    }
    
}

class GetProductResponse: Codable {
    
    var data : [Product]?
    var meta : Meta?
    var nextPage: Int?
    
    init(response: [String: Any]?) {
        guard let response = response else {
            return
        }
        if let productssData = try? JSONSerialization.data(withJSONObject: response.keysToCamelCase, options: []) {
            if let productsResponse = try? JSONDecoder().decode(GetProductResponse.self, from: productssData) {
                self.data = productsResponse.data
                self.meta = productsResponse.meta
                guard let _page = productsResponse.meta?.currentPage else {
                    self.nextPage = nil
                    return
                }
                guard let _totalPages = productsResponse.meta?.lastPage else{
                    self.nextPage = nil
                    return
                }
                if _page == _totalPages {
                    self.nextPage = nil
                    return
                }
                self.nextPage = self.nextPage ?? 0 + 1
                
            }
        }
    }
}


