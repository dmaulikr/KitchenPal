//
//  MyRecipeNutritionViewController.swift
//  KitchenPal
//
//  Created by Michael Zamani on 12/10/14.
//  Copyright (c) 2014 Michael Zamani. All rights reserved.
//

import UIKit
import HealthKit

class MyRecipeNutritionViewController: UIViewController {
    
    // Object reference to this project's AppDelegate
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    // Object reference to Storyboard elements
    @IBOutlet var nutritionTextView: UITextView!
    
    // Nutrition data passed from the upstream view controller
    var nutritionDict: NSDictionary?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Nutrition Information"
        
        var allNutritionDataAsText: String = ""
        
        for quantityType in nutritionDict!.allKeys {
            
            // All quantityType keys begin with "HKQuantityTypeIdentifierDietary" 
            // Create a substring beginning from index 30
            
            let index: String.Index = advance((quantityType as String).startIndex, 30)
            
            var descriptionText = (quantityType as String).substringFromIndex(index)
            
            descriptionText += ":"
            
            var valueAndUnit = nutritionDict!.objectForKey(quantityType) as NSArray
            
            var units: String = valueAndUnit.objectAtIndex(1) as String
            
            var value = String(format: "%.2f", (valueAndUnit.objectAtIndex(0) as Double))
            
            allNutritionDataAsText += " ".join([descriptionText, value, units])
            
            allNutritionDataAsText += "\n"
        }
        
        nutritionTextView.text = allNutritionDataAsText

    }
    
    // MARK: - Log In Health App Button Pressed
    
    @IBAction func logInHealthAppPressed(sender: UIButton) {
        
        for quantityType in nutritionDict!.allKeys {
            
            var nutritionType = HKQuantityType.quantityTypeForIdentifier(quantityType as String)
            
            var valueAndUnit = nutritionDict!.objectForKey(quantityType) as NSArray
            
            var value = valueAndUnit.objectAtIndex(0) as Double
            var unitAbbrev: String = valueAndUnit.objectAtIndex(1) as String
            
            var unit = HKUnit(fromString: unitAbbrev)
            
            var quantity: HKQuantity = HKQuantity(unit: unit, doubleValue: value)
            
            var nutritionObject = HKQuantitySample(type: nutritionType!, quantity: quantity, startDate: NSDate(), endDate: NSDate())
            
            println(quantity)
            println(nutritionType!)
            
            appDelegate.healthStore.saveObject(nutritionObject, withCompletion: nil)
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}
