//
//  Utils.swift
//  eventbriteSearcherSwift
//
//  Created by Leonardo Salmaso on 5/5/16.
//  Copyright © 2016 Leonardo Salmaso. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    private static let dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
    
    static func stringFormattedDate(date: NSDate) -> String? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.stringFromDate(date)
    }
    
    static func dateFromServerSrting(date: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.dateFromString(date)
    }
}
