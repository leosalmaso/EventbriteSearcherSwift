//
//  SearchResultDTO.swift
//  eventbriteSearcherSwift
//
//  Created by Leonardo Salmaso on 5/5/16.
//  Copyright © 2016 Leonardo Salmaso. All rights reserved.
//

import UIKit

struct SearchResultDTO {
    var title: String?
    var place: String?
    var detail: String?
    var imageUrl: String?
    var date: NSDate?
    var tags: Array<String>?
}
