//
//  GeneralData.swift
//  task
//
//  Created by islam on 9/24/20.
//

import Foundation


class Meta: Codable {
    var currentPage : Int?
    var total : Int?
    var perPage : Int?
    var lastPage : Int?
    
    private enum CodingKeys: String, CodingKey {
        case  total, perPage = "per_page" , currentPage = "current_page" , lastPage = "last_page"
    }

}
