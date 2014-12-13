//
//  AddCuisineViewController.swift
//  KitchenPal
//
//  Created by Michael Zamani on 12/2/14.
//  Copyright (c) 2014 Michael Zamani. All rights reserved.
//

import UIKit

class AddCuisineViewController: UIViewController {

    // The data object to pass to the upstream view controller on unwind
    var cuisineToAdd = ""
    
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    var cuisinesToDisplay = [String]()
    
    @IBOutlet var pickerView: UIPickerView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveCuisine:")
        self.navigationItem.rightBarButtonItem = saveButton
        
        self.title = "Add Cuisine Preference"
    }
    
    override func viewWillAppear(animated: Bool) {
        
        cuisinesToDisplay = [String]()
        
        // Sets for allCuisines and the currently selected cuisines used to differentiate between the two
        var allCuisinesSet: NSMutableSet = NSMutableSet(array: appDelegate.allCuisines!)
        var cuisinesSet: NSMutableSet = NSMutableSet(array: appDelegate.cuisines!)
        
        allCuisinesSet.intersectSet(cuisinesSet)
        
        for var i = 0; i < appDelegate.allCuisines!.count; i++ {
            
            if !allCuisinesSet.containsObject(appDelegate.allCuisines!.objectAtIndex(i)) {
                
                cuisinesToDisplay.append(appDelegate.allCuisines!.objectAtIndex(i) as String)
            }
        }
        
        var numberOfCuisines = cuisinesToDisplay.count
        
        // Obtain the number of the row in the middle of the Theaters list
        var numberOfRowToShare = Int(numberOfCuisines / 2)
        
        // Show the picker view of VT place names from the middle
        pickerView.selectRow(numberOfRowToShare, inComponent: 0, animated: false)
    }
    
    // MARK: - Save Button Pressed
    
    func saveCuisine(sender: AnyObject) {
        
        cuisineToAdd = cuisinesToDisplay[pickerView.selectedRowInComponent(0)]
        
        performSegueWithIdentifier("AddCuisine-Save", sender: self)
    }
    
    // MARK: - UIPickerView Data Source Methods
    
    // Returns the number of components in the pickerview.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    // Returns the number of rows in each component in the pickerview.
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return cuisinesToDisplay.count
    }
    
    // MARK: - UIPickerView Delegate Methods
    
    // Returns the Data to be populated into the pickerview for each row
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return cuisinesToDisplay[row]
    }
}
