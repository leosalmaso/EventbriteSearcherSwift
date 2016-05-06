//
//  ApiHelper.swift
//  eventbriteSearcherSwift
//
//  Created by Leonardo Salmaso on 5/5/16.
//  Copyright © 2016 Leonardo Salmaso. All rights reserved.
//

import UIKit
import Alamofire

enum ApiResult {
    case Success(data: AnyObject?)
    case Failure(error: NSError)
}

enum HttpStatuses: Int {
    case AuthenticationError = 401
}

class ApiClient {

    static let sharedInstance: ApiClient = ApiClient()
    
    //Here we could define diferent servers in User settings. For exaple staging, prod, test, etc.
    var baseApiUrl: String {
        return "https://www.eventbriteapi.com/v3"
    }
    
    func searchEvents(query: String, sinceDate: NSDate, latitude: String?, longitude: String?, pageNumber: Int32, callback: ApiResult -> ()) {
    
        let url = baseApiUrl + "/events/search"
        
        var parameters = defaultParameters()
        parameters["q"] = query
        parameters["page"] = String(pageNumber)
        parameters["sort_by"] = "date"
        parameters["start_date.range_start"] = Utils.stringFormattedDate(sinceDate)
        
        if let latitude = latitude {
            parameters["location.latitude"] = latitude
        }
        
        if let longitude = longitude {
            parameters["location.longitude"] = longitude
        }
        
        Alamofire.request(.GET, url, parameters: parameters, encoding: ParameterEncoding.URL, headers: nil).responseJSON { response in
            
            switch response.result {
            case .Success(let data):
                callback(ApiResult.Success(data: data))
                break
            case .Failure(let error):
                callback(ApiResult.Failure(error: error))
                break
            }
        }
    }
    
    func defaultParameters() -> [String: AnyObject] {
        var parameters = [String: AnyObject]()
        parameters["token"] = "TE2TQUT463S6XXJXMVLM"
        
        return parameters;
    }
}