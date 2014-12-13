//
//  AllergiesTableViewController.swift
//  KitchenPal
//
//  Created by Michael Zamani on 12/2/14.
//  Copyright (c) 2014 Michael Zamani. All rights reserved.
//

import UIKit

class AllergiesTableViewController: UITableViewController {

    // Object reference to this View Controller's TableView object
    @IBOutlet var allergiesTableView: UITableView!
    
    // Object reference to the AppDelegate
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addAllergy:")
        
        self.navigationItem.rightBarButtonItems = [addButton, self.editButtonItem()]
    }
    
    // MARK: - Add Allergy Method
    
    func addAllergy(sender: AnyObject) {
        
        if !noAllergiesRemaining() {
            
            // Perform a segue to the AddAllergyViewController
            performSegueWithIdentifier("AddAllergy", sender: self)
        } else {
            
            var alertView = UIAlertView()
            
            alertView.title = "No Allergies Remain!"
            alertView.message = "There are no allergies remaining to be added."
            alertView.addButtonWithTitle("OK")
            alertView.delegate = nil
            
            alertView.show()
        }
        
    }
    
    // MARK: - Data Validation Method
    
    // Returns true if all allergies are already added to the tableview
    func noAllergiesRemaining() -> Bool {
        
        // If the count of the allergies and allAllergies array are equivalent, no allergies remain.
        return appDelegate.allergies!.count == appDelegate.allAllergies!.count
    }

    // MARK: - Table view data source

    // Returns the number of sections in the TableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    // Returns the number of rows (or already selected food allergies)
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return appDelegate.allergies!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AllergyCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        cell.textLabel!.text = appDelegate.allergies![indexPath.row] as? String

        return cell
    }

    // We allow each row (allergy) of the table view to be editable, i.e., deletable.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }

    // This method is invoked when the user taps the Delete button in the Edit mode.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete { // Delete the allergy.
            
            // Deletes the allergy from the user's set allergies
            appDelegate.allergies!.removeObjectAtIndex(indexPath.row)
        }
        
        allergiesTableView.reloadData()
    }
    
    // MARK: - Unwind Segue method
    
    @IBAction func unwindToAllergiesTableViewController(segue: UIStoryboardSegue) {
        
        if segue.identifier == "AddAllergy-Save" {
            
            var controller: AddAllergyViewController = segue.sourceViewController as AddAllergyViewController
            
            if controller.isKindOfClass(AddAllergyViewController) {
                
                var newAllergyName: String = controller.allergyToAdd
                
                // Add the passed allergy to the list user's allergies
                appDelegate.allergies!.addObject(newAllergyName)
                
                allergiesTableView.reloadData()
            }
            
        }
    }
}
