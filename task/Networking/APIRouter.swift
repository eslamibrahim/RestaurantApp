//
//  task
//
//  Created by islam on 9/23/20.
//

import Foundation
import Alamofire


enum APIRouter:URLRequestConvertible {
    
    case getCategoriesList(Parameters)
    case getProductsList(Parameters)
    func asURLRequest() throws -> URLRequest {
        
        var method: HTTPMethod {
            switch self {
            case .getCategoriesList, .getProductsList:
                return .get
            }
        }
        
        let params: ([String: Any]?) = {
            switch self {
            case .getCategoriesList(let param):
                return param
            case .getProductsList(let param):
                return param
            }
        }()
        
        let url: URL = {
            
            // Add base url for the request
            let baseURL:String = {
                return Environment.APIBasePath()
            }()
            
            let apiVersion: String? = {
                return Environment.APIVersionPath()
            }()
            
            // build up and return the URL for each endpoint
            let relativePath: String? = {
                switch self {
                case .getCategoriesList:
                    return "categories" 
                case .getProductsList:
                    return "products"
                }
            }()            
            var urlWithAPIVersion = baseURL
            
            if let apiVersion = apiVersion {
                urlWithAPIVersion = urlWithAPIVersion + apiVersion
            }
            
            var url = URL(string: urlWithAPIVersion)!
            if let relativePath = relativePath {
                url = url.appendingPathComponent(relativePath)
            }
            return url
        }()
        
        let encoding:ParameterEncoding = {
            return URLEncoding.default
        }()
        
        let headers:[String:String]? = {
            let header = ["Authorization" : "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjI1YWVmM2Q5Mjk0MWVmYTEwYWEyNjJkNjdmOGEwZGYwYmFkZDFiYjcyOTBhNjYwYjRmZTMzMzQ4OWM5MzE5NTAxMzc5ZTM1YzNmMTBmZGQ2In0.eyJhdWQiOiI4Zjc4NjY2NC0wNTg5LTQ3MTgtODBkMS1lMTY4M2FmYmM3MjQiLCJqdGkiOiIyNWFlZjNkOTI5NDFlZmExMGFhMjYyZDY3ZjhhMGRmMGJhZGQxYmI3MjkwYTY2MGI0ZmUzMzM0ODljOTMxOTUwMTM3OWUzNWMzZjEwZmRkNiIsImlhdCI6MTYwMDc4MDU3MywibmJmIjoxNjAwNzgwNTczLCJleHAiOjE2MzIzMTY1NzMsInN1YiI6IjhmN2I2NmYwLWE1MjctNGNkNC05MjNkLTYyODM3MDQ1Yjk5NSIsInNjb3BlcyI6WyJnZW5lcmFsLnJlYWQiXSwiYnVzaW5lc3MiOiI4ZjdiNjZmMC1hNTUxLTRlNmYtODU5Mi0wMmRhZjBjNTUzODYiLCJyZWZlcmVuY2UiOiIxMDAwMDAifQ.EvpSUAj0avhQ8oo2nAMDhRvWIa4-SP4JxTOujtJ2V-302ec1eig-S6zJX36FMZG-190o4fYNmWClo_PInt4GLY262zxKYPDrLk0J5RNy3nAaiPFsGPut-o8oJ7RF3ceuRdaGRLaXIpwr7Lj0aok1HxUIBA9dxxu6MTmde6jDmnT2w2vyI_bF3DuAaCeE7A1SpHEwr5dUddkzZbIGoEhxxdfXmbvhP5Hob90uf0vt5R0bxAvBF3m2OVmlK3jEA25TxSbArell3hwvC0aKRcQ5qsDb3Q8zjm-LGYCkiF2jYZbtzB85noE4kfIVbpz4GcrIclWWiWBrnqHeoWbStnjrbtMQ2_m6ZvuOEuNqrI689fwUv1DsXm79_RkRMCveqk3LEEWhaz5ErX3Lfre27GmU96E-xd3CYH1ClgFmFRIVoDfnLjfUz9_3QExgg5xGMieKBHAYDqgduQOMVwCldOsmi0SXQoUtQaILe1IGOIjXQIrU_YUb86ggNasjziUfXpS5iOviRbUM3pEeoFhzMSKJjl2vGuQNoGIVuV_dZsbE5C4gYNfBEmSq3URFwbOhdAHsXq0cTKmfsgjDciFPR6xw_AlsWKJyceYNjzJaL7tAx5hUaEBBHkSvMnZ916fCEdKr6kcjqA2XLEqpkfkRcZCLZbyCdMq1UyUv26lrKUpDVR4"]
            return header
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        
        let _url = try encoding.encode(urlRequest, with: params)
        
        return _url
    }
}
