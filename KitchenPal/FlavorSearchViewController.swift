//
//  FlavorSearchViewController.swift
//  KitchenPal
//
//  Created by Michael Zamani on 11/30/14.
//  Copyright (c) 2014 Michael Zamani. All rights reserved.
//

import UIKit

class FlavorSearchViewController: UIViewController, UIScrollViewDelegate {

    
    // Object references to   labels displaying the current slider value.
    @IBOutlet var piquantLabel: UILabel!
    @IBOutlet var bitterLabel: UILabel!
    @IBOutlet var sweetLabel: UILabel!
    @IBOutlet var meatyLabel: UILabel!
    @IBOutlet var saltyLabel: UILabel!
    @IBOutlet var sourLabel: UILabel!
    
    // Object references to labels displaying the min/max flavor values
    @IBOutlet var minPiquantLabel: UILabel!
    @IBOutlet var maxPiquantLabel: UILabel!
    @IBOutlet var minSweetLabel: UILabel!
    @IBOutlet var maxSweetLabel: UILabel!
    @IBOutlet var minSourLabel: UILabel!
    @IBOutlet var maxSourLabel: UILabel!
    @IBOutlet var minBitterLabel: UILabel!
    @IBOutlet var maxBitterLabel: UILabel!
    @IBOutlet var minSaltyLabel: UILabel!
    @IBOutlet var maxSaltyLabel: UILabel!
    @IBOutlet var minMeatyLabel: UILabel!
    @IBOutlet var maxMeatyLabel: UILabel!
    
    // Create an array of min labels and an array of max labels
    var minLabels = [UILabel]()
    
    var maxLabels = [UILabel]()
    
    var sliderLabels = [UILabel]()
    
    var flavorNames = [String]()
    
    // An array of ingredients to be passed to the downstream view controller
    var dataObjectToPass = [String: [Float]]()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the sliderLabels array with the slider labels.
        
        sliderLabels = [piquantLabel, sweetLabel, sourLabel,
        bitterLabel, saltyLabel, meatyLabel]
        
        // Initialize the minLabels and maxLabels arrays with the labels.
        // This allows the labels to be accessed by their tag number.
        
        minLabels = [minPiquantLabel, minSweetLabel, minSourLabel,
                minBitterLabel, minSaltyLabel, minMeatyLabel]
        
        maxLabels = [maxPiquantLabel, maxSweetLabel, maxSourLabel,
        maxBitterLabel, maxSaltyLabel, maxMeatyLabel]
        
        flavorNames = ["piquant", "sweet", "sour", "bitter", "salty", "meaty"]
    }
    
    // MARK: - Button Pressed Methods
    
    @IBAction func setMinButtonPressed(sender: UIButton) {
        
        var buttonTag: Int = sender.tag
        
        if validMin(buttonTag) {
            
            minLabels[buttonTag].text = "Min: \(sliderLabels[buttonTag].text!)"
            
        } else {
            
            showErrorMessageFor("The value for min must be less than max. Please try again.")
        }
    }
    
    @IBAction func setMaxButtonPressed(sender: UIButton) {
        
        var buttonTag: Int = sender.tag
        
        if validMax(buttonTag) {
        
            maxLabels[buttonTag].text = "Max: \(sliderLabels[buttonTag].text!)"
            
        } else {
            
            showErrorMessageFor("The value for max must be greater than min. Please try again.")
        }
    }
    
    @IBAction func clearButtonPressed(sender: UIButton) {
        
        var buttonTag: Int = sender.tag
        
        minLabels[buttonTag].text = "Min: 0.00"
        maxLabels[buttonTag].text = "Max: 1.00"
    }
    
    // MARK: - Slider Value Changed Methods
    
    @IBAction func sliderChanged(sender: UISlider) {
        
        // Get the tag number of the slider.
        var sliderTag: Int = sender.tag
        
        // Sets the label text to the slider value
        sliderLabels[sliderTag].text = String(format: "%0.2f", sender.value)
    }
    
    
    
    // MARK: - Search Button Pressed
    
    @IBAction func searchButtonPressed(sender: UIButton) {
        
        for var i = 0; i < flavorNames.count; i++ {
            
            var minValue = getValueFromLabel(minLabels[i])
            var maxValue = getValueFromLabel(maxLabels[i])
            
            dataObjectToPass[flavorNames[i]] = [minValue,
                maxValue]
        }
        
        performSegueWithIdentifier("SearchRecipes", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SearchRecipes" {
            
            // Pass data to the downstream view controller
            var controller: FlavorSearchTableViewController = segue.destinationViewController as FlavorSearchTableViewController
            
            // Pass the array of data to the downstream view controller.
            controller.dataObjectPassed = dataObjectToPass
        }
        
    }
    
    // MARK: - Label Data Extraction
    
    func getValueFromLabel(label: UILabel) -> Float {
        
        var labelText: String = label.text!
        
        // Splits the string into two parts, the type of the label and the float value.
        var labelTextComponents: [String] = labelText.componentsSeparatedByString(": ")
        
        // Returns the float value of the second component.
        return (labelTextComponents[1] as NSString).floatValue
    }
    
    // MARK: - Data Validation methods
    
    // Validates the min value.
    func validMin(tagNumber: Int) -> Bool {
        
        var potentialMinValue = (sliderLabels[tagNumber].text! as NSString).floatValue
        var currentMaxValue = getValueFromLabel(maxLabels[tagNumber])
        
        return potentialMinValue <= currentMaxValue
    }
    
    // Validates the max value.
    func validMax(tagNumber: Int) -> Bool {
        
        var potentialMaxValue = (sliderLabels[tagNumber].text! as NSString).floatValue
        var currentMinValue = getValueFromLabel(minLabels[tagNumber])
        
        return potentialMaxValue >= currentMinValue
    }

    // MARK: - Show Error Message method
    
    func showErrorMessageFor(errorString: String) {
        
        var alertView = UIAlertView()
        
        alertView.title = "Unable to Obtain Data!"
        alertView.message = errorString
        alertView.delegate = nil
        alertView.addButtonWithTitle("OK")
        
        alertView.show()
    }

}
