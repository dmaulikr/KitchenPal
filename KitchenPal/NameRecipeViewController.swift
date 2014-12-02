//
//  NameRecipeViewController.swift
//  KitchenPal
//
//  Created by Michael Zamani on 11/24/14.
//  Copyright (c) 2014 Michael Zamani. All rights reserved.
//

import UIKit

class NameRecipeViewController: UIViewController, UIScrollViewDelegate {
    
    // Object references to the UI elements
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var recipeNameLabel: UILabel!
    @IBOutlet var totalPrepTimeLabel: UILabel!
    @IBOutlet var recipeYieldLabel: UILabel!
    @IBOutlet var recipeRatingLabel: UILabel!
    
    @IBOutlet var ingredientsListTextView: UITextView!
    
    @IBOutlet var piquantFlavorLabel: UILabel!
    @IBOutlet var piquantFlavorSlider: UISlider!
    
    @IBOutlet var bitterFlavorLabel: UILabel!
    @IBOutlet var bitterFlavorSlider: UISlider!
    
    @IBOutlet var sweetFlavorLabel: UILabel!
    @IBOutlet var sweetFlavorSlider: UISlider!
    
    @IBOutlet var meatyFlavorLabel: UILabel!
    @IBOutlet var meatyFlavorSlider: UISlider!
    
    @IBOutlet var saltyFlavorLabel: UILabel!
    @IBOutlet var saltyFlavorSlider: UISlider!
    
    @IBOutlet var sourFlavorLabel: UILabel!
    @IBOutlet var sourFlavorSlider: UISlider!
    
    @IBOutlet var attributionTextView: UITextView!
    
    @IBOutlet var logoImageView: UIImageView!
    
    // Data objects passed from the upstream view controller, and to pass to the
    // downstream view controller.
    var selectedRecipeID = ""
    var dataObjectToPass = ["Dish Name", "Preparation Steps URL"]
    
    // A dictionary containing the data for the selected recipe
    var recipeDataDictionary = [String: AnyObject]()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var apiRequestUrl = "http://api.yummly.com/v1/api/recipe/\(selectedRecipeID)?_app_id=22abf91e&_app_key=31a068acb6a8df2e9cd4cd70e41774e6"
        
        var url = NSURL(string: apiRequestUrl)
        
        var jsonError: NSError?
        
        let jsonData: NSData? = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMapped, error: &jsonError)
        
        if let jsonDataFromURL = jsonData {
            
            // JSON Data successfully retrieved.
            
            let jsonDataDictionary = NSJSONSerialization.JSONObjectWithData(jsonDataFromURL, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as NSDictionary
            
            // Typecast the returned dictionary as Dictionary<String, AnyObject>
            recipeDataDictionary = jsonDataDictionary as Dictionary<String, AnyObject>
            
        } else {
            
            // JSON Data unsuccessfully retrieved.
            showErrorMessageFor("Error in retrieving JSON data: \(jsonError!.localizedDescription)")
            return
        }
        
        
        /*
        ------------------------------------
        Set the Recipe Image
        ------------------------------------
        */
        
        var recipeImagesArray = recipeDataDictionary["images"] as Array<AnyObject>
        
        if !recipeImagesArray.isEmpty {
            
            
            var recipeImages = recipeImagesArray[0] as Dictionary<String, AnyObject>
            
            var recipeImageURL: String?
            
            var recipesPresent = recipeImages.keys
            
            
            // Use the medium image if present, followed by the large, and if neither exist then use the
            // small image.
            if contains(recipesPresent, "hostedMediumUrl") {
                
                recipeImageURL = recipeImages["hostedMediumUrl"] as? String
            } else if contains(recipesPresent, "hostedLargeUrl") {
                
                recipeImageURL = recipeImages["hostedLargeUrl"] as? String
            } else {
                
                recipeImageURL = recipeImages["hostedSmallUrl"] as? String
            }
            
            
            var url = NSURL(string: recipeImageURL!)
            
            var errorInReadingImageData: NSError?
            
            // Retrieves the recipe thumbnail image data from the thumbnail URL
            var imageData: NSData? = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &errorInReadingImageData)
            
            if let recipeImage = imageData {
                
                // Recipe thumbnail image data is successfully retrieved
                recipeImageView.image = UIImage(data: recipeImage)
                
            } else {
                
                showErrorMessageFor("Error occurred while retrieving recipe image data!")
            }
        }
        
        
        
        
        /*
        ---------------------------------------------------------
        Set the Recipe Name, Prep Time, Yield, and Rating labels
        ---------------------------------------------------------
        */
        
        var recipeName = recipeDataDictionary["name"] as? String
        recipeNameLabel.text = recipeName
        self.title = recipeName
        
        var totalPrepTime = recipeDataDictionary["totalTime"] as? String
        
        if let prepTimeForRecipe = totalPrepTime {
            
            totalPrepTimeLabel.text = prepTimeForRecipe
        } else {
            
            totalPrepTimeLabel.text = "Prep Time: N/A"
        }
        
        var recipeYield = recipeDataDictionary["yield"] as? String
        
        if let yieldForRecipe = recipeYield {
            
            recipeYieldLabel.text = yieldForRecipe
        } else {
            
            recipeYieldLabel.text = "Yield: N/A"
        }
        
        var recipeRating: Float? = recipeDataDictionary["rating"] as Float?
        
        if let ratingForRecipe = recipeRating {
            
            recipeRatingLabel.text = "Rating: \(ratingForRecipe) / 5.0"
        } else {
            
            recipeRatingLabel.text = "Rating: N/A"
        }
        
        /*
        ------------------------------------
        Sets the ingredients list
        ------------------------------------
        */
        
        var recipeIngredients = recipeDataDictionary["ingredientLines"] as Array<String>
        
        
        ingredientsListTextView.text = "\n".join(recipeIngredients)
        
        /*
        ------------------------------------
        Sets the flavor labels and sliders
        ------------------------------------
        */
        
        var flavorsDict = recipeDataDictionary["flavors"] as Dictionary<String, Float>
        
        var piquantValue = flavorsDict["Piquant"]
        
        if let piquantFlavor = piquantValue {
            
            piquantFlavorLabel.text = String(format: "Spicy: %0.2f", piquantValue!)
            piquantFlavorSlider.value = piquantFlavor
        } else {
            
            piquantFlavorLabel.text = "Spicy: N/A"
        }
        
        
        var bitterValue = flavorsDict["Bitter"]
        
        if let bitterFlavor = bitterValue {
            
            bitterFlavorLabel.text = String(format: "Bitter: %0.2f", bitterValue!)
            bitterFlavorSlider.value = bitterFlavor
        } else {
            
            bitterFlavorLabel.text = "Bitter: N/A"
        }
        
        var sweetValue = flavorsDict["Sweet"]
        
        if let sweetFlavor = sweetValue {
            
            sweetFlavorLabel.text = String(format: "Sweet: %0.2f", sweetValue!)
            sweetFlavorSlider.value = sweetFlavor
        } else {
            
            sweetFlavorLabel.text = "Sweet: N/A"
        }
        
        var meatyValue = flavorsDict["Meaty"]
        
        if let meatyFlavor = meatyValue {
            
            meatyFlavorLabel.text = String(format: "Savory: %0.2f", meatyValue!)
            meatyFlavorSlider.value = meatyFlavor
        } else {
            
            meatyFlavorLabel.text = "Savory: N/A"
        }
        
        var saltyValue = flavorsDict["Salty"]
        
        if let saltyFlavor = saltyValue {
            
            saltyFlavorLabel.text = String(format: "Salty: %0.2f", saltyValue!)
            saltyFlavorSlider.value = saltyValue!
        } else {
            
            saltyFlavorLabel.text = "Salty: N/A"
        }
        
        var sourValue = flavorsDict["Sour"]
        
        if let sourFlavor = sourValue {
            
            sourFlavorLabel.text = String(format: "Sour: %0.2f", sourValue!)
            sourFlavorSlider.value = sourFlavor
        } else {
            
            sourFlavorLabel.text = "Sour: N/A"
        }
        
        /*
        ------------------------------------
        Sets the attribution text view, and the logo image view
        ------------------------------------
        */
        
        var attributionDict = recipeDataDictionary["attribution"] as Dictionary<String, String>
        var yummlyText = attributionDict["text"]
        var yummlyURL = attributionDict["url"]
        var yummlyLogoURL = attributionDict["logo"]
        
        var sourceDict = recipeDataDictionary["source"] as Dictionary<String, String>
        var sourceDisplayName = sourceDict["sourceDisplayName"]
        
        var attributionString = "\(sourceDisplayName!)\n\(yummlyText!)\n\(yummlyURL!)"
        
        attributionTextView.text = attributionString
        
        if let logoImageURL = yummlyLogoURL {
            
            var url = NSURL(string: logoImageURL)
            
            var errorInReadingImageData: NSError?
            
            // Retrieves the recipe thumbnail image data from the thumbnail URL
            var imageData: NSData? = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &errorInReadingImageData)
            
            if let recipeImage = imageData {
                
                // Recipe thumbnail image data is successfully retrieved
                logoImageView.image = UIImage(data: recipeImage)
                
            } else {
                
                // Logo image not loaded.
            }
            
        }
        
    }
    
    // MARK: Display Error Message
    
    func showErrorMessageFor(errorString: String) {
        
        var alertView = UIAlertView()
        
        alertView.title = "Unable to Obtain Data!"
        alertView.message = errorString
        alertView.delegate = nil
        alertView.addButtonWithTitle("OK")
        
        alertView.show()
    }
    
    // MARK: - UIButton Pressed Methods
    
    @IBAction func viewPreparationStepsPressed(sender: UIButton) {
        
        dataObjectToPass[0] = recipeDataDictionary["name"] as String
        
        var sourceDict = recipeDataDictionary["source"] as Dictionary<String, String>
        
        dataObjectToPass[1] = sourceDict["sourceRecipeUrl"]!
        
        performSegueWithIdentifier("PreparationSteps", sender: self)
        
    }
    
    // Utilize HealthKit to add nutrition estimates to the Health app
    @IBAction func logInHealthAppPressed(sender: UIButton) {
        
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "PreparationSteps" {
            
            var controller: NameWebViewController = segue.destinationViewController as NameWebViewController
            
            // Pass the dish name and preparation step website url downstream
            controller.dataObjectPassed = dataObjectToPass
        }
    }
    
}
