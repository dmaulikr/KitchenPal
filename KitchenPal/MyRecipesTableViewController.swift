//
//  MyRecipesTableViewController.swift
//  KitchenPal
//
//  Created by Michael Zamani on 12/5/14.
//  Copyright (c) 2014 Michael Zamani. All rights reserved.
//

import UIKit

class MyRecipesTableViewController: UITableViewController {
    
    let tableViewRowHeight: CGFloat = 80.0
    
    // Object reference to the AppDelegate object
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    var fileRemoveError: NSError?
    
    var selectedRecipe: NSDictionary?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "newRecipe:")
        
        self.navigationItem.rightBarButtonItem = addButton
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return appDelegate.myRecipes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: RecipeTableViewCell = tableView.dequeueReusableCellWithIdentifier("RecipeCell", forIndexPath: indexPath) as RecipeTableViewCell
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        let row = indexPath.row
        
        var recipeData = appDelegate.myRecipes.objectAtIndex(row) as NSDictionary
        
        // Fetch the image from by using the path provided in the dictionary
        
        var imageName = recipeData.objectForKey("image") as String
        
        let imageAbsoluteFilePath = documentDirectoryPath + "/\(imageName)"
        
        var recipeImage: UIImage? = UIImage(contentsOfFile: imageAbsoluteFilePath)
        
        if let imageForRecipe = recipeImage {
            
            cell.recipeImageView.image = recipeImage
        }
        
        let recipeName = recipeData.objectForKey("name") as String
        let prepTime = recipeData.objectForKey("totalTime") as String
        
        cell.recipeName.text = recipeName
        cell.recipeRating.text = prepTime
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            // Gets the document directory path to
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let documentDirectoryPath = paths[0] as String
            
            let rowNumber = indexPath.row
            
            // Grab the image file path from the recipe data dictionary and remove the data from
            // myRecipes in the appDelegate
            var recipeData = appDelegate.myRecipes.objectAtIndex(rowNumber) as NSDictionary
            appDelegate.myRecipes.removeObjectAtIndex(rowNumber)
            
            var imageFilePathExtension = recipeData.objectForKey("image") as String
            
            let imageFilePath = documentDirectoryPath + "/\(imageFilePathExtension)"
            
            let fileManager = NSFileManager.defaultManager()
            
            let didSucceed = fileManager.removeItemAtPath(imageFilePath, error: &fileRemoveError)
            
            if (!didSucceed) {
                
                showErrorMessage("Error in deleting file: \(fileRemoveError!.localizedDescription)")
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let rowNumber = indexPath.row
        
        selectedRecipe = appDelegate.myRecipes.objectAtIndex(rowNumber) as? NSDictionary
        
        performSegueWithIdentifier("ShowRecipe", sender: self)
    }
    
    // Asks the table view delegate to return the given height of a row
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return tableViewRowHeight
    }
    
    // MARK: - Show Error Message
    
    func showErrorMessage(errorMessage: String) {
        
        var alertView = UIAlertView()
        
        alertView.title = "Unable to Delete Recipe Image"
        alertView.message = errorMessage
        alertView.addButtonWithTitle("OK")
        alertView.delegate = nil
        
        alertView.show()
    }
    
    // MARK: - New Recipe Pressed
    
    func newRecipe(sender: AnyObject) {
        
        performSegueWithIdentifier("NewRecipe", sender: self)
    }
    
    // MARK: - Unwind to MyRecipes
    
    @IBAction func unwindToMyRecipesTableViewController(segue: UIStoryboardSegue) {
        
        if segue.identifier == "NewRecipe-Save" {
            
            var controller: NewRecipeViewController = segue.sourceViewController as NewRecipeViewController
            
            if controller.isKindOfClass(NewRecipeViewController) {
                
                appDelegate.myRecipes.addObject(controller.recipeDataDictionary)
                
                self.tableView.reloadData()
            }
            
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowRecipe" {
            
            var controller: ViewMyRecipeViewController = segue.destinationViewController as ViewMyRecipeViewController
            
            controller.recipeData = selectedRecipe
        }
    }
}
