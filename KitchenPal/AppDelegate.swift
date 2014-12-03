//
//  AppDelegate.swift
//  KitchenPal
//
//  Created by Michael Zamani on 11/9/14.
//  Copyright (c) 2014 Michael Zamani. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // An array of all allergies entered by the user.
    var allergies: NSMutableArray = NSMutableArray.alloc()
    
    // A string representation of the diet that the user selected.
    var diet: String = ""
    
    // An array of cuisine preferences selected by the user.
    var cuisines: NSMutableArray = NSMutableArray.alloc()
    
    var allDiets: NSArray = NSArray.alloc()
    
    var allCuisines: NSArray = NSArray.alloc()
    
    var allAllergies: NSArray = NSArray.alloc()
    
    var dict_allergy_allergyQuery = NSDictionary.alloc()
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        /*
        All application-specific and user data must be written to files that reside in the iOS device's
        Documents directory. Nothing can be written into application's main bundle (project folder) because
        it is locked for writing after your app is published.
        
        The contents of the iOS device's Documents directory are backed up by iTunes during backup of an iOS device.
        Therefore, the user can recover the data written by your app from an earlier device backup.
        
        The Documents directory path on an iOS device is different from the one used for iOS Simulator.
        
        To obtain the Documents directory path, you use the NSSearchPathForDirectoriesInDomains function.
        However, this function was created originally for Mac OS X, where multiple such directories could exist.
        Therefore, it returns an array of paths rather than a single path.
        
        For iOS, the resulting array's first element (index=0) contains the path to the Documents directory.
        */
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        let dietaryPreferencePlistFilePathInDocumentDirectory = documentDirectoryPath + "/DietaryPreference.plist"
        let cuisinePreferencesPlistFilePathInDocumentDirectory = documentDirectoryPath + "/CuisinePreferences.plist"
        let foodAllergiesPlistFilePathInDocumentDirectory = documentDirectoryPath + "/FoodAllergies.plist"
        
        // NSMutableDictionary manages an *unordered* collection of mutable (changeable) key-value pairs.
        // Instantiate an NSMutableDictionary object and initialize it with the contents of the MyFavoriteMovies.plist file
        var dietFromFile: NSMutableArray? = NSMutableArray(contentsOfFile: dietaryPreferencePlistFilePathInDocumentDirectory)
        
        var cuisinesFromFile: NSMutableArray? = NSMutableArray(contentsOfFile: cuisinePreferencesPlistFilePathInDocumentDirectory)
        
        var allergiesFromFile: NSMutableArray? = NSMutableArray(contentsOfFile: foodAllergiesPlistFilePathInDocumentDirectory)
        
        /*
        If the optional variable dictionaryFromFile has a value, then
        MyFavoriteMovies.plist exists in the Document directory and the dictionary is successfully created
        else read MyFavoriteMovies.plist from the application's main bundle.
        */
        if let arrayFromFileInDocumentDirectory = dietFromFile {
            
            // DietaryPreferences.plist exists in the Document directory
            self.diet = arrayFromFileInDocumentDirectory[0] as String
            
        } else {
            
            // DietaryPreference.plist does not exist in the Document directory; Set the default diet String to be empty.
            
            self.diet = ""
            
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
        
        // Obtain the file path to the Diets plist file in the mainBundle (project folder)
        var dietsPlistFilePathInMainBundle = NSBundle.mainBundle().pathForResource("Diets", ofType: "plist")
        
        // Instantiate an NSMutableArray object and initialize it with the contents of the Diets.plist file
        var dietsArrayFromFileInMainBundle: NSMutableArray? = NSMutableArray(contentsOfFile: dietsPlistFilePathInMainBundle!)
        
        // Assign the NSMutableArray to the property
        self.allDiets = dietsArrayFromFileInMainBundle!
        
        // Obtain the file path to the Cuisines plist file in the mainBundle (project folder)
        var cuisinesPlistFilePathInMainBundle = NSBundle.mainBundle().pathForResource("Cuisines", ofType: "plist")
        
        // Instantiate an NSMutableArray object and initialize it with the contents of the Diets.plist file
        var cuisinesArrayFromFileInMainBundle: NSMutableArray? = NSMutableArray(contentsOfFile: cuisinesPlistFilePathInMainBundle!)
        
        // Assign the NSMutableArray to the property
        self.allCuisines = cuisinesArrayFromFileInMainBundle!
        
        // Obtain the file path to the Allergies plist file in the mainBundle (project folder)
        var allergiesPlistFilePathInMainBundle = NSBundle.mainBundle().pathForResource("Allergies", ofType: "plist")
        
        // Instantiate an NSMutableArray object and initialize it with the contents of the Allergies.plist file
        var allergiesDictionaryFromFileInMainBundle: NSDictionary? = NSDictionary(contentsOfFile: allergiesPlistFilePathInMainBundle!)
        
        // Assign the NSMutableArray to the property
        self.allAllergies = allergiesDictionaryFromFileInMainBundle!.allKeys
        
        self.dict_allergy_allergyQuery = allergiesDictionaryFromFileInMainBundle!
        
        // Sort the arrays in alphabetical order.
        self.allAllergies.sortedArrayUsingSelector(Selector("localizedCaseInsensitiveCompare:"))
        self.allCuisines.sortedArrayUsingSelector(Selector("localizedCaseInsensitiveCompare:"))
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        /*
        "UIApplicationWillResignActiveNotification is posted when the app is no longer active and loses focus.
        An app is active when it is receiving events. An active app can be said to have focus.
        It gains focus after being launched, loses focus when an overlay window pops up or when the device is
        locked, and gains focus when the device is unlocked." [Apple]
        */
        
        // Define the file path to the plist files in the Document directory
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        let dietaryPreferencePlistFilePathInDocumentDirectory = documentDirectoryPath + "/DietaryPreference.plist"
        let cuisinePreferencesPlistFilePathInDocumentDirectory = documentDirectoryPath + "/CuisinePreferences.plist"
        let foodAllergiesPlistFilePathInDocumentDirectory = documentDirectoryPath + "/FoodAllergies.plist"
        
        
        var dietArray: NSMutableArray = NSMutableArray()
        dietArray.addObject(diet)
        
        // Write the arrays to the appropriate plist files in the Document directory
        
        dietArray.writeToFile(dietaryPreferencePlistFilePathInDocumentDirectory, atomically: true)
        cuisines.writeToFile(cuisinePreferencesPlistFilePathInDocumentDirectory, atomically: true)
        allergies.writeToFile(foodAllergiesPlistFilePathInDocumentDirectory, atomically: true)
        
        /*
        The flag "atomically" specifies whether the file should be written atomically or not.
        
        If flag is TRUE, the dictionary is first written to an auxiliary file, and
        then the auxiliary file is renamed to path plistFilePathInDocumentDirectory.
        
        If flag is FALSE, the dictionary is written directly to path plistFilePathInDocumentDirectory.
        This is a bad idea since the file can be corrupted if the system crashes during writing.
        
        The TRUE option guarantees that the file will not be corrupted even if the system crashes during writing.
        */
    }
    
}

