//
//  IngredientsSearchTableViewController.swift
//  KitchenPal
//
//  Created by Michael Zamani on 11/30/14.
//  Copyright (c) 2014 Michael Zamani. All rights reserved.
//

import UIKit

class IngredientsSearchTableViewController: UITableViewController {
    
    // Get the object reference to the AppDelegate object for this application.
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    let tableViewRowHeight: CGFloat = 80.0
    
    // The search query for the entered data from the upstream view controller.
    var recipeSearchQuery = ""
    
    // The array of data to pass to the downstream view controller
    var dataObjectPassed = [String]()
    
    // recipesMatchingSearchQuery is an Array of Dictionaries, where each Dictionary contains data about a recipe.
    var recipesMatchingSearchQuery = [AnyObject]()
    
    // The number of recipes to display
    var numberOfRecipesToDisplay = 0
    
    // The recipe data to pass to the downstream view controller
    var recipeIDToPass = ""
    
    // An object reference to the UITableView
    @IBOutlet var recipeTableView: UITableView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search Results"
        
        var dictionaryOfRecipesMatchingSearchQuery = [String: AnyObject]()
        
        for var i = 0; i < dataObjectPassed.count; i++ {
            dataObjectPassed[i] = dataObjectPassed[i].stringByReplacingOccurrencesOfString(" ", withString: "+", options: nil, range: nil)
        }
        
        // The API URL containing my APP ID and App Key, with allowed ingredients appended.
        // Only fetches results with pictures, and fetches the top 20 results.
        
        var apiURL: String = "http://api.yummly.com/v1/api/recipes?_app_id=22abf91e&_app_key=31a068acb6a8df2e9cd4cd70e41774e6"
        
        // Append required ingredients to the API query
        for ingredient in dataObjectPassed {
            
            apiURL += "&allowedIngredient[]=\(ingredient)"
        }
        
        // Append any allergies to the API query
        for allergy in appDelegate.allergies! {
            
            var allergyQuery = appDelegate.dict_Allergy_AllergyQuery!.objectForKey(allergy)! as String
            
            allergyQuery = allergyQuery.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            
            apiURL += "&allowedAllergy[]=\(allergyQuery)"
            
        }
        
        // Append any prefered cuisines to the API query
        for cuisine in appDelegate.cuisines! {
            
            var cuisineQuery = appDelegate.dict_Cuisine_CuisineQuery!.objectForKey(cuisine)! as String
            
            cuisineQuery = cuisineQuery.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            
            apiURL += "&allowedAllergy[]=\(cuisineQuery)"
        }
        
        // If the user has selected a required diet, append it to the API query
        if !appDelegate.diet.isEmpty {
            
            var dietQuery = appDelegate.dict_Diet_DietQuery!.objectForKey(appDelegate.diet)! as String
            
            dietQuery = dietQuery.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            
            apiURL += "&allowedDiet[]=\(dietQuery)"
        }
        
        // Require recipes with pictures and display a maximum of 20 recipe results
        apiURL += "&requirePictures=true&maxResult=20"
        
        // Fetches the JSON data resulting from the API call
        
        var url = NSURL(string: apiURL)
        
        var jsonError: NSError?
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let jsonData: NSData? = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMapped, error: &jsonError)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        if let jsonDataFromURL = jsonData {
            
            // JSON Data successfully retrieved.
            
            let jsonDataDictionary = NSJSONSerialization.JSONObjectWithData(jsonDataFromURL, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as NSDictionary
            
            // Typecast the returned dictionary as Dictionary<String, AnyObject>
            dictionaryOfRecipesMatchingSearchQuery = jsonDataDictionary as Dictionary<String, AnyObject>
            
            // recipesMatchingSearchQuery is an Array of Dictionaries, where each Dictionary contains data about a recipe
            recipesMatchingSearchQuery = dictionaryOfRecipesMatchingSearchQuery["matches"] as Array<AnyObject>
            
            numberOfRecipesToDisplay = recipesMatchingSearchQuery.count
            
        } else {
            
            // JSON Data unsuccessfully retrieved.
            showErrorMessageFor("Error in retrieving JSON data: \(jsonError!.localizedDescription)")
        }
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
    
    // MARK: - Table view data source
    
    // Asks the data source to return the number of sections in the table view
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    // Asks the data source to return the number of rows in a section, the number of which is given
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return numberOfRecipesToDisplay
    }
    
    /*
    ------------------------------------
    Prepare and Return a Table View Cell
    ------------------------------------
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let rowNumber: Int = indexPath.row // Identify the row number
        
        // Obtain the object reference of a reusable table view cell object instantiated under the identifier
        // RecipeCell, which was specified in the storyboard
        
        let cell: RecipeTableViewCell = tableView.dequeueReusableCellWithIdentifier("RecipeCell", forIndexPath: indexPath) as RecipeTableViewCell
        
        // Obtain the dictionary containing the data about the recipe at rowNumber
        let recipeDataDict = recipesMatchingSearchQuery[rowNumber] as Dictionary<String, AnyObject>
        
        //-----------------------
        // Set Recipe Thumbnail Image
        //----------------------
        
        let imageUrlsArray = recipeDataDict["smallImageUrls"] as Array<String>
        let thumbnailURL = imageUrlsArray[0] as String
        
        var url = NSURL(string: thumbnailURL)
        
        var errorInReadingImageData: NSError?
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        // Retrieves the recipe thumbnail image data from the thumbnail URL
        var imageData: NSData? = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &errorInReadingImageData)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        if let recipeImage = imageData {
            
            // Recipe thumbnail image data is successfully retrieved
            cell.recipeImageView!.image = UIImage(data: recipeImage)
            
        } else {
            
            showErrorMessageFor("Error occurred while retrieving recipe image data!")
        }
        
        //----------------
        // Set Recipe Name
        //----------------
        
        let recipeName = recipeDataDict["recipeName"] as String
        
        cell.recipeName!.text = recipeName
        
        //------------------------
        // Set Recipe Rating
        //------------------------
        
        var recipeRating: AnyObject? = recipeDataDict["rating"]
        
        cell.recipeRating!.text = "Rating: \(recipeRating!)/5"
        
        return cell
    }
    
    // MARK: - Table View Delegate methods
    
    // Asks the table view delegate to return the given height of a row
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return tableViewRowHeight
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var rowNumber: Int = indexPath.row // Identify the row number
        
        // Obtain the Dictionary containing the data about the selected recipe to pass to the downstream view controller
        var recipeSelected = recipesMatchingSearchQuery[rowNumber] as Dictionary<String, AnyObject>
        
        recipeIDToPass = recipeSelected["id"] as String
        
        performSegueWithIdentifier("ShowRecipe", sender: self)
    }
    
    // MARK: - Prepare for Segue method
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowRecipe" {
            
            var controller: IngredientsRecipeViewController = segue.destinationViewController as IngredientsRecipeViewController
            
            // Pass the Recipe ID to the downstream view controller
            controller.selectedRecipeID = recipeIDToPass
        }
    }
    
}
