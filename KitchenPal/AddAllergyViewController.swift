//
//  AddAllergyViewController.swift
//  KitchenPal
//
//  Created by Michael Zamani on 12/2/14.
//  Copyright (c) 2014 Michael Zamani. All rights reserved.
//

import UIKit

class AddAllergyViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    var allergiesToDisplay = [String]()
    
    @IBOutlet var pickerView: UIPickerView!

    var allergyToAdd = ""
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let saveButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveAllergy:")
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    override func viewWillAppear(animated: Bool) {
        
        allergiesToDisplay = [String]()
        
        var allAllergiesSet: NSMutableSet = NSMutableSet(array: appDelegate.allAllergies)
        var allergiesSet: NSMutableSet = NSMutableSet(array: appDelegate.allergies)
        
        allAllergiesSet.intersectSet(allergiesSet)
        
        for var i = 0; i < appDelegate.allAllergies.count; i++ {
            
            if !allAllergiesSet.containsObject(appDelegate.allAllergies.objectAtIndex(i)) {
                
                allergiesToDisplay.append(appDelegate.allAllergies.objectAtIndex(i) as String)
            }
        }
        
        var numberOfAllergies = allergiesToDisplay.count
        
        // Obtain the number of the row in the middle of the Theaters list
        var numberOfRowToShare = Int(numberOfAllergies / 2)
        
        // Show the picker view of VT place names from the middle
        pickerView.selectRow(numberOfRowToShare, inComponent: 0, animated: false)
    }
    
    // MARK: - Save Button Pressed
    
    func saveAllergy(sender: AnyObject) {
        
        allergyToAdd = allergiesToDisplay[pickerView.selectedRowInComponent(0)]
        
        performSegueWithIdentifier("AddAllergy-Save", sender: self)
    }
    
    // MARK: - UIPickerView Data Source Methods
    
    // Returns the number of components in the pickerview.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    // Returns the number of rows in each component in the pickerview.
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return allergiesToDisplay.count
    }
    
    // MARK: - UIPickerView Delegate Methods
    
    // Returns the Data to be populated into the pickerview for each row
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return allergiesToDisplay[row]
    }
}
