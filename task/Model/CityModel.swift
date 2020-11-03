//
//  CityModel.swift
//  WeatherAppMVC
//
//  Created by OSX on 9/10/19.
//  Copyright © 2019 eslam. All rights reserved.
//

import Foundation


class CityModel: Codable {
    var id : Int?
    var name :String?
    var  country_code : String?
   private enum CodingKeys: String, CodingKey {
        case name, country_code = "country", id
    }
    
    
}
