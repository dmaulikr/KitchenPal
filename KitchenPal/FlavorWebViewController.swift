//
//  FlavorWebViewController.swift
//  KitchenPal
//
//  Created by Michael Zamani on 11/30/14.
//  Copyright (c) 2014 Michael Zamani. All rights reserved.
//

import UIKit

class FlavorWebViewController: UIViewController {

    // The data passed from the upstream view controller (dish name and the URL for prep steps)
    var dataObjectPassed = ["Dish Name", "Preparation Steps URL"]
    
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = dataObjectPassed[0]
        
        var url = NSURL(string: dataObjectPassed[1])
        
        var request = NSURLRequest(URL: url!)
        
        webView.loadRequest(request)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        
        // If the error is cancelled, ignore it
        if error.code == NSURLErrorCancelled {
            return
        }
        
        // An error occurred during the web page load. Hide the activity indicator in the status bar.
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        // Create the error message in HTML as a character string and store it into the local constant errorString
        let errorString = "<html><font size=+2 color='red'><p>An error occurred: <br />Possible causes for this error:<br />- No network connection<br />- Wrong URL entered<br />- Server computer is down</p></font></html>" + error.localizedDescription
        
        // Display the error message within the UIWebView object
        self.webView.loadHTMLString(errorString, baseURL: nil)
        
    }


}
