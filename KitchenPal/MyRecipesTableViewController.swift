//
//  MyRecipesTableViewController.swift
//  KitchenPal
//
//  Created by Michael Zamani on 12/5/14.
//  Copyright (c) 2014 Michael Zamani. All rights reserved.
//

import UIKit

class MyRecipesTableViewController: UITableViewController {
    
    // Object reference to the AppDelegate object
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
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

    /*
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    
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

}
