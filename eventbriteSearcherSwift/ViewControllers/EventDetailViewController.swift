//
//  EventDetailViewController.swift
//  eventbriteSearcherSwift
//
//  Created by Leonardo Salmaso on 5/5/16.
//  Copyright © 2016 Leonardo Salmaso. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var detail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let detail = detail {
            webView.loadHTMLString(detail, baseURL:nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
