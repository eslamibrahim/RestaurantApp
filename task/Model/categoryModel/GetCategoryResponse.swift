//
//  GetCategoryResponse.swift
//  task
//
//  Created by islam on 9/24/20.
//

import Foundation

class Category: Codable {
    var id : String?
    var name : String?
    
    init(category: CategoryCoreData) {
        self.id = category.id
        self.name = category.name
    }
    init() {
        
    }
}

class GetCategoryResponse: Codable {
    
    var data : [Category]?
    var meta : Meta?
    var nextPage: Int?
    
    init(response: [String: Any]?) {
        guard let response = response else {
            return
        }
        if let CategoriesData = try? JSONSerialization.data(withJSONObject: response.keysToCamelCase, options: []) {
            if let CategoriesResponse = try? JSONDecoder().decode(GetCategoryResponse.self, from: CategoriesData) {
                self.data = CategoriesResponse.data
                self.meta = CategoriesResponse.meta
                guard let _page = CategoriesResponse.meta?.currentPage else {
                    self.nextPage = nil
                    return
                }
                guard let _totalPages = CategoriesResponse.meta?.lastPage else{
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


