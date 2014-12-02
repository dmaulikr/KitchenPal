//
//  NameSearchViewController.swift
//  KitchenPal
//
//  Created by Michael Zamani on 11/24/14.
//  Copyright (c) 2014 Michael Zamani. All rights reserved.
//

import UIKit

class NameSearchViewController: UIViewController {

    @IBOutlet var dishNameTextField: UITextField!
    
    @IBOutlet var maxPrepTimeTextField: UITextField!
    
    // An array of the data objects to pass to the downstream view controller
    var dataObjectToPass = ["Dish Name", "Max Prep Time"]
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Clear the text fields when the view reloads
        dishNameTextField.text = ""
        maxPrepTimeTextField.text = ""
    }

    // MARK: - Search Button Pressed
    
    @IBAction func searchButtonPressed(sender: UIButton) {
        if validateTextFields() {
            
            // Trim whitespace from the beginning and end of the text in the text fields.
            var dishName = dishNameTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            var maxPrepTime = maxPrepTimeTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            // Set the data objects to pass.
            dataObjectToPass[0] = dishName
            dataObjectToPass[1] = maxPrepTime
            
            // Perform a segue to the NameSearceTableViewController
            performSegueWithIdentifier("SearchRecipes", sender: self)
        }
    }
    
    // MARK: - Validate text field data
    func validateTextFields() -> Bool {
        
        let alphanumericCharacters = NSCharacterSet.alphanumericCharacterSet()
        
        let rangeFound = dishNameTextField.text.rangeOfCharacterFromSet(alphanumericCharacters)
        
        // If the dish name text field is empty, display an alert and return false.
        if let containsAlnum = rangeFound {
            
            // The text entered in the text field is valid
            return true
            
        } else {
            
            // Either text field is empty or contains no alphanumeric characters
            
            var alertView = UIAlertView()
            
            alertView.title = "No Dish Name Entered!"
            alertView.message = "Please enter a Dish Name to search  and try again."
            alertView.delegate = nil
            alertView.addButtonWithTitle("OK")
            
            alertView.show()
            
            return false
        }
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SearchRecipes" {
            
            // Pass data to the downstream view controller
            var controller: NameSearchTableViewController = segue.destinationViewController as NameSearchTableViewController
            
            // Pass the array of data to the downstream view controller.
            controller.dataObjectPassed = dataObjectToPass
        }
        
    }

    // MARK: - Keyboard First Responder Methods
    
    // This method is invoked when the user taps the Search button on the keyboard.
    @IBAction func keyboardDone(sender: UITextField) {
        
        // Hides the keyboard by resigning first responder for the selected text field
        sender.resignFirstResponder()
    }
    
    // This method removes the keyboard when the user taps anywhere on the background
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /*
        "A UITouch object represents the presence or movement of a finger on the screen for a particular event." [Apple]
        We store the UITouch object's unique ID into the local variable touch.
        */
        var touch: UITouch = event.allTouches()?.anyObject()? as UITouch
        
        /*
        When the user taps within a text field, that text field becomes the first responder.
        When a text field becomes the first responder, the system automatically displays the keyboard.
        */
        
        // If dishNameTextField is first responder and the user did not touch the dishNameTextField
        if dishNameTextField.isFirstResponder() && touch.view != dishNameTextField {
            
            // Make dishNameTextFild to be no longer the first responder.
            dishNameTextField.resignFirstResponder()
        }
        
        // If maxPrepTimeTextField is first responder and the user did not touch the maxPrepTimeTextField
        if maxPrepTimeTextField.isFirstResponder() && touch.view != maxPrepTimeTextField {
            
            // Make maxPrepTimeTextField to longer be the first responder.
            maxPrepTimeTextField.resignFirstResponder()
        }
        
        super.touchesBegan(touches, withEvent:event)
    }
    
}
