//
//  AppDelegate.swift
//  KitchenPal
//
//  Created by Michael Zamani on 11/9/14.
//  Copyright (c) 2014 Michael Zamani. All rights reserved.
//

import UIKit
import HealthKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // A global property to interface with the user's HealthKit database.
    var healthStore: HKHealthStore = HKHealthStore()
    
    // An array of all allergies entered by the user.
    var allergies: NSMutableArray = NSMutableArray.alloc()
    
    // A string representation of the diet that the user selected.
    var diet: String = ""
    
    // An array of cuisine preferences selected by the user.
    var cuisines: NSMutableArray = NSMutableArray.alloc()
    
    var allDiets: NSArray = NSArray.alloc()
    var allCuisines: NSArray = NSArray.alloc()
    var allAllergies: NSArray = NSArray.alloc()
    
    var dict_Allergy_AllergyQuery = NSDictionary.alloc()
    var dict_Cuisine_CuisineQuery = NSDictionary.alloc()
    var dict_Diet_DietQuery = NSDictionary.alloc()
    var dict_NutritionAttribute_HealthKitIdentifier = NSDictionary.alloc()
    
    var myRecipes = NSMutableArray.alloc()
    
    var healthKitIdentifiersArray = NSArray.alloc()
    
    var allowableUnitSet = NSSet(array: ["g", "kcal"])
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        let dietaryPreferencePlistFilePathInDocumentDirectory = documentDirectoryPath + "/DietaryPreference.plist"
        let cuisinePreferencesPlistFilePathInDocumentDirectory = documentDirectoryPath + "/CuisinePreferences.plist"
        let foodAllergiesPlistFilePathInDocumentDirectory = documentDirectoryPath + "/FoodAllergies.plist"
        let myRecipesPlistFilePathInDocumentDirectory = documentDirectoryPath + "/MyRecipes.plist"
        
        var dietFromFile: NSMutableArray? = NSMutableArray(contentsOfFile: dietaryPreferencePlistFilePathInDocumentDirectory)
        
        var cuisinesFromFile: NSMutableArray? = NSMutableArray(contentsOfFile: cuisinePreferencesPlistFilePathInDocumentDirectory)
        
        var allergiesFromFile: NSMutableArray? = NSMutableArray(contentsOfFile: foodAllergiesPlistFilePathInDocumentDirectory)
        
        var myRecipesFromFile: NSMutableArray? = NSMutableArray(contentsOfFile: myRecipesPlistFilePathInDocumentDirectory)
        
        
        if let arrayFromFileInDocumentDirectory = dietFromFile {
            
            // DietaryPreferences.plist exists in the Document directory
            self.diet = arrayFromFileInDocumentDirectory[0] as String
            
        } else {
            
            // DietaryPreference.plist does not exist in the Document directory; Set the default diet String to be empty.
            
            self.diet = "None"
            
        }
        
        if let arrayFromFileInDocumentDirectory = cuisinesFromFile {
            
            // CuisinePreferences.plist exists in the Document directory
            self.cuisines = arrayFromFileInDocumentDirectory
            
            
        } else {
            
            // CuisinePreferences.plist does not exist in the Document directory; Set the default cuisine array to be empty.
            self.cuisines = NSMutableArray()
            
        }
        
        if let arrayFromFileInDocumentDirectory = allergiesFromFile {
            
            // FoodAllergies.plist exists in the Document Directory
            self.allergies = arrayFromFileInDocumentDirectory
            
            
        } else {
            
            // FoodAllergies.plist does not exist in the Document directory; set the default allergy array to be empty.
            self.allergies = NSMutableArray()
        }
        
        if let arrayFromFileInDocumentDirectory = myRecipesFromFile {
            
            // MyRecipes.plist exists in the Document Directory
            self.myRecipes = arrayFromFileInDocumentDirectory
            
        } else {
            
            self.myRecipes = NSMutableArray.alloc()
        }
        
        // Obtain the file path to the Diets plist file in the mainBundle (project folder)
        var dietsPlistFilePathInMainBundle = NSBundle.mainBundle().pathForResource("Diets", ofType: "plist")
        
        // Instantiate an NSMutableArray object and initialize it with the contents of the Diets.plist file
        var dietsDictionaryFromFileInMainBundle: NSDictionary? = NSDictionary(contentsOfFile: dietsPlistFilePathInMainBundle!)
        
        // Assign the NSMutableArray to the property
        self.dict_Diet_DietQuery = dietsDictionaryFromFileInMainBundle!
        self.allDiets = dict_Diet_DietQuery.allKeys
        
        // Obtain the file path to the Cuisines plist file in the mainBundle (project folder)
        var cuisinesPlistFilePathInMainBundle = NSBundle.mainBundle().pathForResource("Cuisines", ofType: "plist")
        
        // Instantiate an NSMutableArray object and initialize it with the contents of the Diets.plist file
        var cuisinesDictionaryFromFileInMainBundle: NSDictionary? = NSDictionary(contentsOfFile: cuisinesPlistFilePathInMainBundle!)
        
        // Assign the NSMutableArray to the property
        self.dict_Cuisine_CuisineQuery = cuisinesDictionaryFromFileInMainBundle
        self.allCuisines = dict_Cuisine_CuisineQuery.allKeys
        
        // Obtain the file path to the Allergies plist file in the mainBundle (project folder)
        var allergiesPlistFilePathInMainBundle = NSBundle.mainBundle().pathForResource("Allergies", ofType: "plist")
        
        // Instantiate an NSMutableArray object and initialize it with the contents of the Allergies.plist file
        var allergiesDictionaryFromFileInMainBundle: NSDictionary? = NSDictionary(contentsOfFile: allergiesPlistFilePathInMainBundle!)
        
        var hkIdentifiersPlistFilePathInMainBundle = NSBundle.mainBundle().pathForResource("HKIdentifiers", ofType: "plist")
        
        self.dict_NutritionAttribute_HealthKitIdentifier = NSDictionary(contentsOfFile: hkIdentifiersPlistFilePathInMainBundle!)

        self.dict_Allergy_AllergyQuery = allergiesDictionaryFromFileInMainBundle!
        self.allAllergies = dict_Allergy_AllergyQuery!.allKeys
        
        // Sort the arrays in alphabetical order.
        self.allAllergies.sortedArrayUsingSelector(Selector("localizedCaseInsensitiveCompare:"))
        self.allCuisines.sortedArrayUsingSelector(Selector("localizedCaseInsensitiveCompare:"))
        
        var types = [HKObjectType]()
        
        for quantityType in dict_NutritionAttribute_HealthKitIdentifier.allValues {
            
            types.append(HKObjectType.quantityTypeForIdentifier(quantityType as String))
        }
        
        var hkIdentifiersArrayPlistFilePathInMainBundle = NSBundle.mainBundle().pathForResource("HKIdentifierList", ofType: "plist")
        
        healthKitIdentifiersArray = NSArray(contentsOfFile: hkIdentifiersArrayPlistFilePathInMainBundle!)
        
        var typesToShare = NSSet(array: types)
        
        self.healthStore.requestAuthorizationToShareTypes(typesToShare, readTypes: nil, completion: {
            (success, error) in
            if success {
                println("User completed authorisation request.")
            } else {
                println("The user cancelled the authorisation request. \(error)")
            }
        })
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        
        // Define the file path to the plist files in the Document directory
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        let dietaryPreferencePlistFilePathInDocumentDirectory = documentDirectoryPath + "/DietaryPreference.plist"
        let cuisinePreferencesPlistFilePathInDocumentDirectory = documentDirectoryPath + "/CuisinePreferences.plist"
        let foodAllergiesPlistFilePathInDocumentDirectory = documentDirectoryPath + "/FoodAllergies.plist"
        let myRecipesPlistFilePathInDocumentDirectory = documentDirectoryPath + "/MyRecipes.plist"
        
        
        var dietArray: NSMutableArray = NSMutableArray()
        dietArray.addObject(diet)
        
        // Write the arrays to the appropriate plist files in the Document directory
        
        dietArray.writeToFile(dietaryPreferencePlistFilePathInDocumentDirectory, atomically: true)
        cuisines.writeToFile(cuisinePreferencesPlistFilePathInDocumentDirectory, atomically: true)
        allergies.writeToFile(foodAllergiesPlistFilePathInDocumentDirectory, atomically: true)
        myRecipes.writeToFile(myRecipesPlistFilePathInDocumentDirectory, atomically: true)
    }
    
}

