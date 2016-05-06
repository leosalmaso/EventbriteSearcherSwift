    //
    //  SearchViewController.swift
    //  eventbriteSearcherSwift
    //
    //  Created by Leonardo Salmaso on 5/5/16.
    //  Copyright © 2016 Leonardo Salmaso. All rights reserved.
    //
    
    import UIKit
    
    class SearchViewController: UIViewController {
        
        let cellIdentifier = "SearchResultIdentifier"
        
        @IBOutlet weak var tableView: UITableView!
        @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
        @IBOutlet weak var searchControl: UISearchBar!
        @IBOutlet weak var noItemsLabel: UILabel!
        
        var currentPage = 0
        var detailToShow: String?
        var events = Array<SearchResultDTO>()
        var formatter = NSDateFormatter()
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let gmt = NSTimeZone(abbreviation: "GMT")
            formatter.dateFormat = "EEE, MMM dd, hh:mm"
            formatter.timeZone = gmt
        }
        
        override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)
            
            if LocationManager.sharedInstance.validatePermission() == .Authorized {
                //To use other way to send messages between objects, I wanted to show you the notification center
                
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchViewController.waitForLocationAuthorization(_:)) , name:LocationManager.locationAuthorizationChanged, object: nil)
            } else {
                //load empty query by default
                fetchEvents("" , pageNumber:0);
            }
        }
        
        func waitForLocationAuthorization(notification: NSNotification) {
            NSNotificationCenter.defaultCenter().removeObserver(self)
            fetchEvents("" , pageNumber:0);
        }
        
        
        func fetchEvents(query: String, pageNumber: Int32) {
            
            if pageNumber == 0 {
                tableView.hidden = true
                self.noItemsLabel.hidden = true
                self.activityIndicator.startAnimating()
            }
            
            EventsManager.sharedInstance.searchEvents(query, sinceDate: NSDate(), pageNumber: pageNumber) { (response, error) in
                self.tableView.hidden = false
                self.activityIndicator.stopAnimating()
                
                if error == nil {
                    if let newEvents = response {
                        if pageNumber == 0 {
                            self.events = newEvents
                        } else {
                            self.events.appendContentsOf(newEvents)
                        }
                        
                        if self.events.count == 0 {
                            self.noItemsLabel.hidden = false
                        } else {
                            self.noItemsLabel.hidden = true;
                        }
                        
                        self.tableView.reloadData()
                    }
                } else {
                    let alerController = UIAlertController(title: "Error", message: NSLocalizedString("Error trying to fetch events", comment: "") , preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                    alerController.addAction(okAction)
                    
                    self.presentViewController(alerController, animated: true, completion: nil)
                }
            }
        }
        
        func loadMoreSearchItems(rowNumber: Int) {
            
            if rowNumber == events.count - 10 {
                currentPage += 1;
                fetchEvents(searchControl.text!, pageNumber: Int32(rowNumber))
            }
        }
        
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == "showEventDetail" {
                if let vc = segue.destinationViewController as? EventDetailViewController {
                    vc.detail = detailToShow
                }
            }
        }
    }
    
    extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return events.count
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let currentEvent = events[indexPath.row];
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as! SearchResultTableViewCell
            
            cell.eventTitle.text = currentEvent.title
            
            if let date = currentEvent.date {
                cell.eventDate.text = formatter.stringFromDate(date)
            }
            
            loadMoreSearchItems(indexPath.row)
            return cell
        }
        
        func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 300
        }
        
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            let dto = self.events[indexPath.row];
            detailToShow = dto.detail;
            performSegueWithIdentifier("showEventDetail", sender:self)
        }
    }
    
    extension SearchViewController: UISearchBarDelegate {
        func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
            NSObject.cancelPreviousPerformRequestsWithTarget(self)
            self.performSelector(#selector(SearchViewController.sendSearchRequest), withObject:searchText, afterDelay:0.5)
        }
        
        func sendSearchRequest(searchText: String?) {
            //Search always starts in page 0
            fetchEvents(searchText!, pageNumber:0)
        }
        
    }
