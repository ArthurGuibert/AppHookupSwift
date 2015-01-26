//
//  AppListViewController.swift
//  AppHookupSwift
//
//  Created by Arthur GUIBERT on 25/01/2015.
//  Copyright (c) 2015 Arthur GUIBERT. All rights reserved.
//

import UIKit
import StoreKit

class AppListViewController: UITableViewController, SKStoreProductViewControllerDelegate, UIActionSheetDelegate
{
    var applications:[Application] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Regestering the custom cell we're going to use
        var nib = UINib(nibName: "ApplicationTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "ApplicationCell")
        
        tableView.separatorColor = UIColor(white: 1, alpha: 1)
        
        // Fetching the application online
        Application.fetchApplications("hot", {(applications: Array<Application>) -> Void in
            self.applications = applications
        })
        
        // Register an observer to update the table view once all the data has been downloaded
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let mainQueue = NSOperationQueue.mainQueue()
        
        notificationCenter.addObserverForName("ApplicationDataLoaded", object: nil, queue: mainQueue) { _ in
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let app: Application = applications[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier("ApplicationCell") as ApplicationTableViewCell
        
        cell.appName!.text = app.title
        cell.appIcon?.image = app.image
        cell.appPublisher?.text = app.publisher
        cell.appPrice?.text = app.price;
        
        cell.appIcon.layer.cornerRadius = cell.appIcon.frame.size.width / 2
        cell.appIcon.layer.masksToBounds = true
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applications.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app: Application = applications[indexPath.row]
        var modal = SKStoreProductViewController()
        modal.loadProductWithParameters([SKStoreProductParameterITunesItemIdentifier : app.appId!], completionBlock: nil)
        modal.delegate = self
        presentViewController(modal, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80;
    }
    
    func productViewControllerDidFinish(viewController: SKStoreProductViewController!) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func order(sender: AnyObject) {
        let sheet = UIActionSheet(title: "Sorting options", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "hot", "new")
        sheet.showInView(UIApplication.sharedApplication().keyWindow)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex > 0 {
            Application.fetchApplications(["hot","new"][buttonIndex - 1], {(applications: Array<Application>) -> Void in
                self.applications = applications
            })
        }
    }
}
