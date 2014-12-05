//
//  CuisineTableViewController.swift
//  KitchenPal
//
//  Created by Michael Zamani on 12/5/14.
//  Copyright (c) 2014 Michael Zamani. All rights reserved.
//

import UIKit

class CuisineTableViewController: UITableViewController {

    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addCuisine:")
        
        // Must manually link editing button to edit table view action.
        self.navigationItem.rightBarButtonItems = [addButton, self.editButtonItem()]
        
        self.title = "Cuisines"
    }
    
    // MARK: - Table view data source
    
    // Returns the number of sections in the TableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    // Returns the number of rows (or already selected cuisines)
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return appDelegate.cuisines.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CuisineCell", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        cell.textLabel!.text = appDelegate.cuisines[indexPath.row] as? String
        
        return cell
    }
    
    // We allow each row (cuisine) of the table view to be editable, i.e., deletable.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    // This method is invoked when the user taps the Delete button in the Edit mode.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete { // Delete the cuisine.
            
            appDelegate.cuisines.removeObjectAtIndex(indexPath.row)
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Unwind Segue method
    
    @IBAction func unwindToCuisineTableViewController(segue: UIStoryboardSegue) {
        
        if segue.identifier == "AddCuisine-Save" {
            
            var controller: AddCuisineViewController = segue.sourceViewController as AddCuisineViewController
            
            if controller.isKindOfClass(AddCuisineViewController) {
                
                var newCuisineName: String = controller.cuisineToAdd
                
                appDelegate.cuisines.addObject(newCuisineName)
                
                self.tableView.reloadData()
            }
            
        }
    }
    
    // MARK: - Add Cuisine Method
    
    func addCuisine(sender: AnyObject) {
        
        if !noCuisinesRemaining() {
            
            // Perform a segue to the AddCuisineViewController
            performSegueWithIdentifier("AddCuisine", sender: self)
        } else {
            
            var alertView = UIAlertView()
            
            alertView.title = "No Cuisines Remain!"
            alertView.message = "There are no cuisines remaining to be added."
            alertView.addButtonWithTitle("OK")
            alertView.delegate = nil
            
            alertView.show()
        }
        
    }
    
    // MARK: - Data validation
    
    func noCuisinesRemaining() -> Bool {
        
        // If the count of the cuisines and allCuisines array are equivalent, no cuisines remain.
        return appDelegate.cuisines.count == appDelegate.allCuisines.count
    }
    
}
