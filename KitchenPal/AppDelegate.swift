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
    var allergies: NSMutableArray?
    
    // A string representation of the diet that the user selected.
    var diet: String = ""
    
    // An array of cuisine preferences selected by the user.
    var cuisines: NSMutableArray?
    
    // Arrays storing all of the diet, cuisine and allergy information loaded from plists
    var allDiets: NSArray?
    var allCuisines: NSArray?
    var allAllergies: NSArray?
    
    // Dictionaries mapping allergy, cuisine and diets to their query values for the Yummly API
    var dict_Allergy_AllergyQuery: NSDictionary?
    var dict_Cuisine_CuisineQuery: NSDictionary?
    var dict_Diet_DietQuery: NSDictionary?
    
    // A Dictionary mapping the Yummly API nutrition attribute to the corresponding HealtKit identifier.
    var dict_NutritionAttribute_HealthKitIdentifier: NSDictionary?
    
    // An array of all of the users "MyRecipe" recipes loaded from the documents directory
    var myRecipes: NSMutableArray?
    
    // An array of the HealthKit Identifiers for nutrition
    var healthKitIdentifiersArray: NSArray?
    
    // A set of the allowable units that are offered by the Yummly API and accepted by the HealthKit framework
    var allowableUnitSet = NSSet(array: ["g", "kcal"])
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Gets the path for the document directory
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        // The paths for all of the plist files stored in the user's document directory
        let dietaryPreferencePlistFilePathInDocumentDirectory = documentDirectoryPath + "/DietaryPreference.plist"
        let cuisinePreferencesPlistFilePathInDocumentDirectory = documentDirectoryPath + "/CuisinePreferences.plist"
        let foodAllergiesPlistFilePathInDocumentDirectory = documentDirectoryPath + "/FoodAllergies.plist"
        let myRecipesPlistFilePathInDocumentDirectory = documentDirectoryPath + "/MyRecipes.plist"
        
        // Data loaded from the user's document directory (if it exists)
        var dietFromFile: NSMutableArray? = NSMutableArray(contentsOfFile: dietaryPreferencePlistFilePathInDocumentDirectory)
        var cuisinesFromFile: NSMutableArray? = NSMutableArray(contentsOfFile: cuisinePreferencesPlistFilePathInDocumentDirectory)
        var allergiesFromFile: NSMutableArray? = NSMutableArray(contentsOfFile: foodAllergiesPlistFilePathInDocumentDirectory)
        var myRecipesFromFile: NSMutableArray? = NSMutableArray(contentsOfFile: myRecipesPlistFilePathInDocumentDirectory)
        
        
        // Unwraps and sets the AppDelegate properties to the documents directory data if it exists
        
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
            
            var defaultRecipesFilePathInMainBundle = NSBundle.mainBundle().pathForResource("DefaultRecipes", ofType: "plist")
            
            self.myRecipes = NSMutableArray(contentsOfFile: defaultRecipesFilePathInMainBundle!)
        }
        
        // Obtain the file path to the Diets plist file in the mainBundle (project folder)
        var dietsPlistFilePathInMainBundle = NSBundle.mainBundle().pathForResource("Diets", ofType: "plist")
        
        // Instantiate an NSMutableArray object and initialize it with the contents of the Diets.plist file
        var dietsDictionaryFromFileInMainBundle: NSDictionary? = NSDictionary(contentsOfFile: dietsPlistFilePathInMainBundle!)
        
        // Assign the NSMutableArray to the property
        self.dict_Diet_DietQuery = dietsDictionaryFromFileInMainBundle!
        self.allDiets = dict_Diet_DietQuery!.allKeys
        
        // Obtain the file path to the Cuisines plist file in the mainBundle (project folder)
        var cuisinesPlistFilePathInMainBundle = NSBundle.mainBundle().pathForResource("Cuisines", ofType: "plist")
        
        // Instantiate an NSMutableArray object and initialize it with the contents of the Diets.plist file
        var cuisinesDictionaryFromFileInMainBundle: NSDictionary? = NSDictionary(contentsOfFile: cuisinesPlistFilePathInMainBundle!)
        
        // Assign the NSMutableArray to the property
        self.dict_Cuisine_CuisineQuery = cuisinesDictionaryFromFileInMainBundle
        self.allCuisines = dict_Cuisine_CuisineQuery!.allKeys
        
        var allergiesPlistFilePathInMainBundle = NSBundle.mainBundle().pathForResource("Allergies", ofType: "plist")
        
        var allergiesDictionaryFromFileInMainBundle: NSDictionary? = NSDictionary(contentsOfFile: allergiesPlistFilePathInMainBundle!)
        
        var hkIdentifiersPlistFilePathInMainBundle = NSBundle.mainBundle().pathForResource("HKIdentifiers", ofType: "plist")
        
        self.dict_NutritionAttribute_HealthKitIdentifier = NSDictionary(contentsOfFile: hkIdentifiersPlistFilePathInMainBundle!)

        self.dict_Allergy_AllergyQuery = allergiesDictionaryFromFileInMainBundle!
        self.allAllergies = dict_Allergy_AllergyQuery!.allKeys
        
        // Sort the arrays in alphabetical order.
        self.allAllergies!.sortedArrayUsingSelector(Selector("localizedCaseInsensitiveCompare:"))
        self.allCuisines!.sortedArrayUsingSelector(Selector("localizedCaseInsensitiveCompare:"))
        
        // Loads an array of HealthKit identifiers that this app potentially uses into memory
        var hkIdentifiersArrayPlistFilePathInMainBundle = NSBundle.mainBundle().pathForResource("HKIdentifierList", ofType: "plist")
        
        healthKitIdentifiersArray = NSArray(contentsOfFile: hkIdentifiersArrayPlistFilePathInMainBundle!)
        
        var types = [HKObjectType]()
        
        // Add all of the HKObjectTypes into the types array.
        for quantityType in dict_NutritionAttribute_HealthKitIdentifier!.allValues {
            
            types.append(HKObjectType.quantityTypeForIdentifier(quantityType as String))
        }
        
        // The nutrition types that are potentially writeable by this app, that require permission from the user.
        var typesToShare = NSSet(array: types)
        
        // Requests authorization from the user to write health data to their Health app.
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
        
        // Define the file path to the Document directory
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        // Create the absolute file path to the plist files stored in the user's document directory
        let dietaryPreferencePlistFilePathInDocumentDirectory = documentDirectoryPath + "/DietaryPreference.plist"
        let cuisinePreferencesPlistFilePathInDocumentDirectory = documentDirectoryPath + "/CuisinePreferences.plist"
        let foodAllergiesPlistFilePathInDocumentDirectory = documentDirectoryPath + "/FoodAllergies.plist"
        let myRecipesPlistFilePathInDocumentDirectory = documentDirectoryPath + "/MyRecipes.plist"
        
        // Because only one diet may be selected at any given time, create an array and append the single diet
        // for storage in a plist file.
        var dietArray: NSMutableArray = NSMutableArray()
        dietArray.addObject(diet)
        
        // Write the data to the appropriate plist files in the Document directory
        
        dietArray.writeToFile(dietaryPreferencePlistFilePathInDocumentDirectory, atomically: true)
        cuisines!.writeToFile(cuisinePreferencesPlistFilePathInDocumentDirectory, atomically: true)
        allergies!.writeToFile(foodAllergiesPlistFilePathInDocumentDirectory, atomically: true)
        myRecipes!.writeToFile(myRecipesPlistFilePathInDocumentDirectory, atomically: true)
    }
    
}

