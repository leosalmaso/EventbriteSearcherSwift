//
//  Utils.swift
//  eventbriteSearcherSwift
//
//  Created by Leonardo Salmaso on 5/5/16.
//  Copyright © 2016 Leonardo Salmaso. All rights reserved.
//

import UIKit
import Kingfisher

class Utils {
    
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
    
    class AppActivityIndicator: CustomActivityIndicator {
        init(showInView mainView:UIView) {
            var images: [UIImage] = []
            for countValue in 1...7 {
                let image  = UIImage(named:"frame_\(countValue)")
                images.append(image!)
            }
            
            super.init(width:250, height: 55, images: images, backgroundColor: UIColor.loadingIndicatorBackgroundColor(), showInView: mainView)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

extension UIColor {
    static func colorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIImageView {
    public func app_setImageWithURL(url: NSURL, placeholderImage: UIImage? = nil) {
        kf_setImageWithURL(url, placeholderImage: placeholderImage, optionsInfo: nil)
    }
}
