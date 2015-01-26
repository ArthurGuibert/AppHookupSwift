//
//  Application.swift
//  AppHookupSwift
//
//  Created by Arthur GUIBERT on 25/01/2015.
//  Copyright (c) 2015 Arthur GUIBERT. All rights reserved.
//

import UIKit

class Application {
    var title: String?
    var image: UIImage?
    var price: String?
    var publisher: String?
    let url: String?
    let appId: String?
    
    init (title: String, url: String) {
        self.title = title
        self.url = url
        self.appId = nil
        self.image = nil
    }
    
    init(dict: Dictionary<String, AnyObject>?) {
        let item = dict!["data"] as? Dictionary<String, AnyObject>
        self.title = "..."
        self.url = (item!["url"] as? String)!
        self.image = nil
        self.appId = nil
        self.price = "..."
        self.publisher = " "
        
        if (self.url != nil && self.url!.rangeOfString("itunes.apple.com") != nil) {
            self.appId = self.url!.extractAppIdFromURL()
            loadData()
        }
    }
    
    class func fetchApplications(sorting: String, callback: Array<Application> -> Void) {
        // This function fetch the list of all the apps in the AppHookup subreddit
        var applications: [Application] = []
        APIRequest.request("http://www.reddit.com/r/apphookup/\(sorting).json", parameters: ["limit" : "50"], callback: {(response: AnyObject?) -> Void in
            if response != nil {
                if let dict = response! as? Dictionary<String, AnyObject> {
                    let jsonData = dict["data"] as? Dictionary<String, AnyObject>
                    let children = jsonData!["children"] as? Array<AnyObject>
                    
                    for child in children! {
                        let app = Application(dict: child as? Dictionary<String, AnyObject>)
                        
                        if app.appId != nil {
                            applications.append(app)
                        }
                    }
                    
                    callback(applications)
                }
            }
        });
    }
    
    func loadData() {
        if self.appId != nil {
            APIRequest.request("http://itunes.apple.com/lookup", parameters: ["id" : self.appId!], callback: {(response: AnyObject?) -> Void in
                if response != nil {
                    let results = response as? Dictionary<String, AnyObject>
                    let list = results!["results"] as? Array<AnyObject>
                    
                    if(list!.count > 0) {
                        let dict = list![0] as? Dictionary<String, AnyObject>
                        self.title = dict!["trackName"] as? String
                        self.price = dict!["formattedPrice"] as? String
                        self.publisher = dict!["sellerName"] as? String
                        
                        var imagePath = dict!["artworkUrl60"] as? String
                        
                        if imagePath != nil {
                            self.loadImageFromURL(NSURL(string: imagePath!)!)
                        }
                        
                        self.notifyChanges()
                    }
                }
            })
        }
    }
    
    func loadImageFromURL(url: NSURL) {
        APIRequest.dataFromURL(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                self.image = UIImage(data: data!)
            }
        }
    }
    
    func notifyChanges() {
        // Broadcast the fact that the information is loaded
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.postNotificationName("ApplicationDataLoaded", object: nil)
    }
}