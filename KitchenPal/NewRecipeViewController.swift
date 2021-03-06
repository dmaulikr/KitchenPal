//
//  NewRecipeViewController.swift
//  KitchenPal
//
//  Created by Michael Zamani on 12/5/14.
//  Copyright (c) 2014 Michael Zamani. All rights reserved.
//

import UIKit
import MobileCoreServices

class NewRecipeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // Object reference to the AppDelegate object
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    // Essential text fields
    @IBOutlet var recipeNameTextField: UITextField!
    @IBOutlet var prepTimeTextField: UITextField!
    @IBOutlet var yieldTextField: UITextField!
    @IBOutlet var ingredientsTextField: UITextField!
    @IBOutlet var prepStepsTextView: UITextView!
    
    // Slider Labels
    @IBOutlet var spicyLabel: UILabel!
    @IBOutlet var bitterLabel: UILabel!
    @IBOutlet var sweetLabel: UILabel!
    @IBOutlet var savoryLabel: UILabel!
    @IBOutlet var saltyLabel: UILabel!
    @IBOutlet var sourLabel: UILabel!
    
    // Nutrition Text Fields
    @IBOutlet var energyTextField: UITextField!
    @IBOutlet var totalFatTextField: UITextField!
    @IBOutlet var saturatedFatTextField: UITextField!
    @IBOutlet var proteinTextField: UITextField!
    @IBOutlet var carbohydratesTextField: UITextField!
    @IBOutlet var sugarTextField: UITextField!
    @IBOutlet var fiberTextField: UITextField!
    @IBOutlet var sodiumTextField: UITextField!
    @IBOutlet var potassiumTextField: UITextField!
    @IBOutlet var vitaminATextField: UITextField!
    @IBOutlet var vitaminB6TextField: UITextField!
    @IBOutlet var vitaminB12TextField: UITextField!
    @IBOutlet var vitaminCTextField: UITextField!
    @IBOutlet var vitaminDTextField: UITextField!
    @IBOutlet var calciumTextField: UITextField!
    @IBOutlet var cholesterolTextField: UITextField!
    @IBOutlet var ironTextField: UITextField!
    
    // The slider values and labels for spicy, bitter, sweet, savory, salty, and sour respectively.
    var sliderValues = [Float]()
    var sliderLabels = [UILabel]()
    var essentialTextFields = [UITextField]()
    var optionalTextFields = [UITextField]()
    
    @IBOutlet var recipePicture: UIImageView?
    
    // Dictionary property storing the recipe infrormation (if the recipe is saved.)
    var recipeDataDictionary = NSMutableDictionary()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize sliderValues to 0.0
        sliderValues = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        
        // Store references for sliders in array to allow retrieval using slider tags
        sliderLabels = [spicyLabel, bitterLabel, sweetLabel, savoryLabel, saltyLabel, sourLabel]
        
        // stores references to essential text fields in array to allow easy iteration
        essentialTextFields = [recipeNameTextField, prepTimeTextField, yieldTextField, ingredientsTextField]
        
        // Stores the optional text fields in an array to allow easy iteration, and access using the text field tags.
        optionalTextFields = [energyTextField, totalFatTextField, saturatedFatTextField, proteinTextField, carbohydratesTextField, sugarTextField, fiberTextField, sodiumTextField, potassiumTextField, vitaminATextField, vitaminB6TextField, vitaminB12TextField, vitaminCTextField, vitaminDTextField, calciumTextField, cholesterolTextField, ironTextField]
        
        var saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveRecipe:")
        self.navigationItem.rightBarButtonItem = saveButton
        
        self.title = "New Recipe"
    }
    
    // MARK: - UIImagePicker Delegate method
    
    // Takes a picture using a UIImagePicker and returns a photo
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        let selectedImage : UIImage = image
        
        recipePicture!.image = selectedImage
        
        // Dismissed the UIImagePicker view once the picture is taken
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Capture Recipe Photo pressed
    
    // If the user's device has
    @IBAction func captureRecipePhoto(sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            var imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.mediaTypes = [kUTTypeImage]
            imagePicker.allowsEditing = false
            
            // Presents the UIImagePicker to allowe the user to take a photo.
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        } else {
            
            var alertView = UIAlertView()
            
            alertView.title = "No Camera on Current Device!"
            alertView.message = "Sorry, there is no camera available on your current device."
            alertView.addButtonWithTitle("OK")
            alertView.delegate = nil
            
            alertView.show()
        }
    }
    
    // MARK: -  Save Recipe Pressed
    
    func saveRecipe(sender: AnyObject) {
        
        if validateData() {
            
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let documentDirectoryPath = paths[0] as String
            
            recipeDataDictionary.setObject(recipeNameTextField.text, forKey: "name")
            recipeDataDictionary.setObject(prepTimeTextField.text, forKey: "totalTime")
            recipeDataDictionary.setObject(yieldTextField.text, forKey: "yield")
            
            // Stores each ingredient as an element in an array.
            var ingredients: [String] = ingredientsTextField.text.componentsSeparatedByString(",")
            
            for var i = 0; i < ingredients.count; i++ {
                
                ingredients[i] = ingredients[i].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            }
            
            recipeDataDictionary.setObject(ingredients, forKey: "ingredientLines")
            
            // Save the image in the document directory using the current time (to prevent overwriting)
            
            let currentTime = NSDate()
            
            var fileNameInDocumentDirectory: String = "KitchenPal-\(currentTime)"
            
            var imageData: NSData = UIImageJPEGRepresentation(recipePicture!.image, 0.9)
            
            var absoluteFilePathToSaveImage = documentDirectoryPath + "/\(fileNameInDocumentDirectory)"
            
            imageData.writeToFile(absoluteFilePathToSaveImage, atomically: true)
            
            // Store the file path for the image in the recipe dictionary
            
            recipeDataDictionary.setObject(fileNameInDocumentDirectory, forKey: "image")
            
            recipeDataDictionary.setObject(prepStepsTextView.text, forKey: "preparationSteps")
            
            // Store the nutrition information in the dictionary
            
            var nutritionDict = NSMutableDictionary()
            
            for textField in optionalTextFields {
                
                if !textField.text.isEmpty {
                    
                    // If a number can be parsed from the string
                    if let value = NSNumberFormatter().numberFromString(textField.text) {
                        
                        // Subtracts 1 due to tag 0 being associated with all other text field
                        let tag = textField.tag - 1
                            
                        let identifier = (appDelegate.healthKitIdentifiersArray!.objectAtIndex(tag) as NSArray).objectAtIndex(0) as String
                        
                        let unit = (appDelegate.healthKitIdentifiersArray!.objectAtIndex(tag) as NSArray).objectAtIndex(1) as String
                            
                        nutritionDict.setObject([value.doubleValue, unit], forKey: identifier)
                    }
                }
            }
            
            recipeDataDictionary.setObject(nutritionDict, forKey: "nutrition")
            
            // Store the flavor info in the dictionary
            
            var flavorDict = NSMutableDictionary()
            
            for var i = 0; i < sliderValues.count; i++ {
                
                let flavorValue = sliderValues[i]
                var flavorType = (sliderLabels[i].text! as String).componentsSeparatedByString(": ")[0]
                
                flavorDict[flavorType] = flavorValue
            }
            
            recipeDataDictionary.setObject(flavorDict, forKey: "flavors")
            
            performSegueWithIdentifier("NewRecipe-Save", sender: self)
        }
    }
    
    // MARK: - Data Validation
    
    func validateData() -> Bool {
        
        for textField in essentialTextFields {
            
            if textField.text.isEmpty {
                
                showErrorMessageFor("Please fill in all non-optional text fields and try again.")
                return false
            }
        }
        
        if prepStepsTextView.text.isEmpty {
            
            showErrorMessageFor("Please provide preparation steps for this recipe.")
            return false
        }
        
        if recipePicture?.image == nil {
            
            showErrorMessageFor("Please provide a photo for recipe.")
            return false
        }
        
        return true
    }
    
    // MARK: - Show Error Message
    
    func showErrorMessageFor(error: String) {
        
        var alertView = UIAlertView()
        
        alertView.title = "Missing Required Information!"
        alertView.message = error
        alertView.delegate = nil
        alertView.addButtonWithTitle("OK")
        
        alertView.show()
    }
    
    // MARK: - Slider Value Changed
    @IBAction func sliderChanged(sender: UISlider) {
        
        var tagNumber = sender.tag
        
        var sliderLabel = sliderLabels[tagNumber]
        var sliderLabelText = sliderLabel.text!
        var sliderTitle = sliderLabelText.componentsSeparatedByString(" ")[0]
        
        var sliderValue = String(format: "%.2f", sender.value)
        
        sliderLabel.text = "\(sliderTitle) \(sliderValue)"
        
        sliderValues[tagNumber] = sender.value
    }
    
    // MARK: - Keyboard First Responder Methods
    
    // This method is invoked when the user taps the Search button on the keyboard.
    @IBAction func keyboardDone(sender: UITextField) {
        
        // Hides the keyboard by resigning first responder for the selected text field
        sender.resignFirstResponder()
    }
    
    // This method removes the keyboard when the user taps anywhere on the background
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {

        var touch: UITouch = event.allTouches()?.anyObject()? as UITouch
        
        /*
        When the user taps within a text field, that text field becomes the first responder.
        When a text field becomes the first responder, the system automatically displays the keyboard.
        */
        
        for textField in essentialTextFields {
            
            if textField.isFirstResponder() && touch.view != textField {
                
                textField.resignFirstResponder()
            }
        }
        
        for textField in optionalTextFields {
            
            if textField.isFirstResponder() && touch.view != textField {
                
                textField.resignFirstResponder()
            }
        }
        
        if prepStepsTextView.isFirstResponder() && touch.view != prepStepsTextView {
            
            prepStepsTextView.resignFirstResponder()
        }
        
        super.touchesBegan(touches, withEvent: event)
    }

}
