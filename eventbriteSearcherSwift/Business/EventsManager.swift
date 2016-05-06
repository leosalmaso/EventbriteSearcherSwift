//
//  EventsManager.swift
//  eventbriteSearcherSwift
//
//  Created by Leonardo Salmaso on 5/5/16.
//  Copyright © 2016 Leonardo Salmaso. All rights reserved.
//

import UIKit

class EventsManager: NSObject {

    static let sharedInstance: EventsManager = EventsManager()
        
        
    func searchEvents(query: String, sinceDate: NSDate, pageNumber: Int32, completionClosure:(response: Array<SearchResultDTO>?, error: NSError?) -> Void) {
        
        var latitude: String?
        var longitude: String?
        
        if LocationManager.sharedInstance.validatePermission() == .Authorized {
            if let currentLocation = LocationManager.sharedInstance.lastCoordinate {
                latitude = String(currentLocation.latitude)
                longitude = String (currentLocation.longitude)
            }
        }

        ApiClient.sharedInstance.searchEvents(query, sinceDate: sinceDate, latitude: latitude, longitude: longitude, pageNumber: pageNumber) { result in
            
            switch result {
                
            case .Success(let data):
                var nearEvents = Array<SearchResultDTO>()
                
                if let data = data {
                    if let events = data ["events"] as? Array<Dictionary<String, AnyObject>> {
                        for event in events {
                            var dto = SearchResultDTO()
                            dto.place = ""
                            
                            if let name = event["name"], let nameText = name["text"] {
                                dto.title = nameText as? String
                            }
                            
                            if let detail = event["description"], let detailText = detail["html"] {
                                dto.detail = detailText as? String
                            }
                            
                            if let logo = event["logo"], logoUrl = logo["url"] {
                                //To improve this I need to consider the aspect ratio
                                dto.imageUrl = logoUrl as? String
                            }
                            
                            if let start = event["start"], startLocalTime = start["local"] {
                                //To improve this I need to consider the aspect ratio
                                dto.date = Utils.dateFromServerSrting(startLocalTime as! String)
                            }
                            
                            nearEvents.append(dto)
                        }
                        
                        completionClosure(response: nearEvents, error: nil)
                    } else if let errorMessage = data["error_description"] as? String {
                        
                        //I should have a better error handler, but for the sample this is fine.
                        let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey:errorMessage]
                        let error = NSError(domain: "eventbriteSearcherSwift", code: 900, userInfo: userInfo)
                        completionClosure(response: nil, error: error)
                    }
                }
                
                break
                
            case .Failure(let error):
                completionClosure(response: nil, error: error)
                break
            }
        }
    }
}
