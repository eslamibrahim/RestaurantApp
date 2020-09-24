//  task
//
//  Created by islam on 9/23/20.
//


import Foundation

enum Server {
    case developement
    case staging
    case production
}

class Environment {

    static let server:Server    =   .developement
    
    // To print the log set true.
    static let debug:Bool       =   true
    
    class func APIBasePath() -> String {
        switch self.server {
            case .developement:
            //    return "https://api.themoviedb.org/"
               return  "https://api.foodics.dev/"
            case .staging:
                return ""
            case .production:
                return ""
        }
    }
    
    class func APIVersionPath() -> String {
        switch self.server {
        case .developement:
            return "v5/"
        case .staging:
            return ""
        case .production:
            return ""
        }
    }
    
    class func MOVIEDB_APIKEY() -> String {
        switch self.server {
        case .developement:
            return "14bc774791d9d20b3a138bb6e26e2579"
        case .staging:
            return ""
        case .production:
            return ""
        }
    }
    
}


