//
//  NameNutritionViewController.swift
//  KitchenPal
//
//  Created by Michael Zamani on 12/4/14.
//  Copyright (c) 2014 Michael Zamani. All rights reserved.
//

import UIKit
import HealthKit

class NameNutritionViewController: UIViewController {

    // Object reference to the AppDelegate
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    // Object reference to a text view displaying the nutrtion data for this recipe.
    @IBOutlet var nutritionInfoTextView: UITextView!
    
    // The nutrition information for this dish represented as an array of dictionaries (for each nutrient)
    var nutritionData = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Nutrition Information"
        
        var allNutritionDataAsText: String = ""
        
        // Append all of the nutrition estimates to a string to be displayed in the text view
        
        for nutrientDict in nutritionData {
            
            if nutrientDict.allKeys.count == 0 {
                
                // Skip this entry
                continue
            }
            
            var descriptionText = nutrientDict.objectForKey("attribute") as String
            
            descriptionText += ":"
            
            var unitData: AnyObject = nutrientDict.objectForKey("unit")!
            
            var value = String(format: "%.2f", (nutrientDict.objectForKey("value") as Double))
            
            var pluralUnits = unitData.objectForKey("plural") as String
            
            allNutritionDataAsText += " ".join([descriptionText, value, pluralUnits])
            
            allNutritionDataAsText += "\n"
        }
        
        nutritionInfoTextView.text = allNutritionDataAsText
    }
    
    // Log the nutrition estimates in the user's Health app
    @IBAction func logInHealthAppPressed(sender: UIButton) {
        
        var unit: HKUnit?
        var nutritionType: HKQuantityType?
        var value: Double
        
        // For each nutrition estimate, log in the Health app using this application's HealthStore object
        
        for nutrientInfo in nutritionData {
            
            var quantityType: String? = appDelegate.dict_NutritionAttribute_HealthKitIdentifier!.objectForKey(nutrientInfo.objectForKey("attribute")!) as String?
            
            if let quantityTypeForNutrient = quantityType {
                
                nutritionType = HKQuantityType.quantityTypeForIdentifier(quantityTypeForNutrient)
                var unitDict: AnyObject? = nutrientInfo.objectForKey("unit")
                value = nutrientInfo.objectForKey("value") as Double
                var unitAbbrev: String = unitDict?.objectForKey("abbreviation") as String
                
                if !appDelegate.allowableUnitSet.containsObject(unitAbbrev) {
                    
                    // If unit not recognized, skip this nutrition estimate.
                    continue
                }
                
                unit = HKUnit(fromString: unitAbbrev)
                
                var quantity: HKQuantity = HKQuantity(unit: unit, doubleValue: value)
                
                var nutritionObject = HKQuantitySample(type: nutritionType!, quantity: quantity, startDate: NSDate(), endDate: NSDate())
                
                appDelegate.healthStore.saveObject(nutritionObject, withCompletion: nil)
                
            }
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}
