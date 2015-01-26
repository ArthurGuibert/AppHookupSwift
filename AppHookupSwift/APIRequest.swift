//
//  APIRequest.swift
//  AppHookupSwift
//
//  Created by Arthur GUIBERT on 25/01/2015.
//  Copyright (c) 2015 Arthur GUIBERT. All rights reserved.
//

import Foundation

class APIRequest {
    // Small function to retrieve a json from an URL + parameters
    class func request(baseUrl: String, parameters: Dictionary<String,String>,callback: AnyObject? -> Void) {
        var fullUrl = baseUrl + "?"
        
        for (key, value) in parameters {
            fullUrl += key + "=" + value + "&"
        }
        
        let request = NSURLRequest(URL: NSURL(string: fullUrl)!)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            var jsonError: NSError?
            let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &jsonError)
            
            if jsonError == nil && json != nil {
                callback(json)
            } else {
                callback(nil)
            }
        }
        
        task.resume()
    }
    
    class func dataFromURL(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        let task = NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: NSData(data: data))
        }
        
        task.resume()
    }
}