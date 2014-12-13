//
//  ViewMyRecipeViewController.swift
//  KitchenPal
//
//  Created by Michael Zamani on 12/10/14.
//  Copyright (c) 2014 Michael Zamani. All rights reserved.
//

import UIKit
import Darwin

extension UIImage {
    
    // Returns a normalized (in the correct orientation and size) version of the image
    func normalizedImage() -> UIImage {
        
        // If the image is already in the correct orientation, return it.
        if self.imageOrientation == UIImageOrientation.Up {
            
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        self.drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
        var normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage
    }
}

class ViewMyRecipeViewController: UIViewController {

    // Dictionary containing recipe data passed from the upstream view controller
    var recipeData: NSDictionary?
    
    // Object references to the Storyboard elements
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var recipeNameLabel: UILabel!
    @IBOutlet var totalTimeLabel: UILabel!
    @IBOutlet var yieldLabel: UILabel!
    @IBOutlet var ingredientsTextView: UITextView!
    @IBOutlet var prepStepsTextView: UITextView!
    @IBOutlet var spicyLabel: UILabel!
    @IBOutlet var spicySlider: UISlider!
    @IBOutlet var bitterLabel: UILabel!
    @IBOutlet var bitterSlider: UISlider!
    @IBOutlet var sweetLabel: UILabel!
    @IBOutlet var sweetSlider: UISlider!
    @IBOutlet var savoryLabel: UILabel!
    @IBOutlet var savorySlider: UISlider!
    @IBOutlet var saltyLabel: UILabel!
    @IBOutlet var saltySlider: UISlider!
    @IBOutlet var sourLabel: UILabel!
    @IBOutlet var sourSlider: UISlider!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Document directory path for the recipe image
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectoryPath = paths[0] as String

        // Set the Recipe Name as the title and the label text
        
        var recipeName = recipeData!.objectForKey("name") as String
        self.title = recipeName
        recipeNameLabel.text = recipeName
        
        // Total time and yield labels
        
        var totalTime = recipeData!.objectForKey("totalTime") as String
        totalTimeLabel.text = "Preparation Time: \(totalTime)"
        var yield = recipeData!.objectForKey("yield") as String
        yieldLabel.text = "Servings: \(yield)"
        
        // Set the recipe image
        var recipeImagePath = documentDirectoryPath + "/" + (recipeData?.objectForKey("image") as String)
        var recipeImageData = NSData(contentsOfFile: recipeImagePath)
        var recipeImage = UIImage(data: recipeImageData!)
        recipeImageView.image = recipeImage!.normalizedImage()
        
        // Set the ingredients list
        var ingredientsArray = recipeData!.objectForKey("ingredientLines") as [String]
        ingredientsTextView.text = "\n".join(ingredientsArray)
        
        // Set the preparation steps
        var prepSteps = recipeData!.objectForKey("preparationSteps") as String
        prepStepsTextView.text = prepSteps
        
        // Set the flavor slider values
        var flavorDict = recipeData!.objectForKey("flavors") as NSDictionary
        
        let spicyValue = flavorDict.objectForKey("Spicy") as Float
        spicySlider.value = spicyValue
        let spicyText = String(format: "%.2f", spicyValue)
        spicyLabel.text = "Spicy: \(spicyText)"
        
        let bitterValue = flavorDict.objectForKey("Bitter") as Float
        bitterSlider.value = bitterValue
        let bitterText = String(format: "%.2f", bitterValue)
        bitterLabel.text = "Bitter: \(bitterText)"
        
        let sweetValue = flavorDict.objectForKey("Sweet") as Float
        sweetSlider.value = sweetValue
        let sweetText = String(format: "%.2f", sweetValue)
        sweetLabel.text = "Sweet: \(sweetText)"
        
        let savoryValue = flavorDict.objectForKey("Savory") as Float
        savorySlider.value = savoryValue
        let savoryText = String(format: "%.2f", savoryValue)
        savoryLabel.text = "Savory: \(savoryText)"
        
        let saltyValue = flavorDict.objectForKey("Salty") as Float
        saltySlider.value = saltyValue
        let saltyText = String(format: "%.2f", saltyValue)
        saltyLabel.text = "Salty: \(saltyText)"
        
        let sourValue = flavorDict.objectForKey("Sour") as Float
        sourSlider.value = sourValue
        let sourText = String(format: "%.2f", sourValue)
        sourLabel.text = "Sour: \(sourText)"
    }
    
    // MARK: - View Nutition Info Pressed
    
    // Display the recipes nutrition data
    @IBAction func viewNutritionInfoPressed(sender: UIButton) {
        
        performSegueWithIdentifier("ShowNutrition", sender: self)
    }
    

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     
        if segue.identifier == "ShowNutrition" {
            
            var controller: MyRecipeNutritionViewController = segue.destinationViewController as MyRecipeNutritionViewController
            
            controller.nutritionDict = recipeData!.objectForKey("nutrition") as? NSDictionary
        }
    }

}
