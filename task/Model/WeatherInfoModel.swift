//
//  Created by OSX on 9/9/19.
//  Copyright © 2019 eslam. All rights reserved.

import Foundation


class  WeatherDetails : Codable{
    var city : CityModel?
    var weatherInfo : [WeatherInfo]?
    private enum CodingKeys: String, CodingKey {
        case  weatherInfo = "list", city = "city"
    }
}

class WeatherInfo :  Codable{
    var weather : [Weather]?
    var aboutTemperature : AboutTemperature?
    var dateText: String?
    private enum CodingKeys: String, CodingKey {
        case  weather, aboutTemperature = "main" , dateText = "dt_txt"
    }
}

struct Weather: Codable {
    var description: String?
    var icon: String?
}

struct AboutTemperature: Codable {
    var temp: Double?
    var tempMax: Double?
    var tempMin: Double?
    private enum CodingKeys: String, CodingKey {
        case temp, tempMax = "temp_max", tempMin = "temp_min"
    }
}

extension WeatherInfo  {
    var iconUrlPath: String {
        guard let iconName = weather?.first?.icon else { return "" }
        return "https://openweathermap.org/img/w/\(iconName).png"
    }
    
    var displayTemperature: Int {
        let value = Int(round(aboutTemperature?.temp ?? 0))
        return value
    }
    
    var displayTemperatureMax: Int {
        let value = Int(round(aboutTemperature?.tempMax ?? 0))
        return value
    }
    
    var displayTemperatureMin: Int {
        let value = Int(round(aboutTemperature?.tempMin ?? 0))
        return value
    }
    
    var weatherDescription: String {
        guard let weatherDescription = weather?.first?.description else { return "" }
        return weatherDescription
    }
}



