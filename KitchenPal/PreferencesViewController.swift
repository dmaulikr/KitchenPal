//
//  DietCuisineViewController.swift
//  KitchenPal
//
//  Created by Michael Zamani on 12/2/14.
//  Copyright (c) 2014 Michael Zamani. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController {
    
    @IBOutlet var leftArrowWhite: UIImageView!
    @IBOutlet var rightArrowWhite: UIImageView!
    
    // References to the Storyboard objects
    @IBOutlet var scrollMenu: UIScrollView!
    
    // Other properties (instance variables) and their initializations
    let kScrollMenuHeight: CGFloat = 30.0
    var previousButton = UIButton(frame: CGRectMake(0, 0, 0, 0))
    
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        ---------------------
        Set up the Scroll Menu
        ---------------------
        */
        leftArrowWhite.backgroundColor = UIColor.blueColor()
        rightArrowWhite.backgroundColor = UIColor.blueColor()
        scrollMenu.backgroundColor = UIColor.blueColor()
        
        // Instantiate a mutable array to hold the buttons (diet selections)
        var listOfMenuButtons = [UIButton]()
        
        for var i = 0; i < appDelegate.allDiets.count; i++ {
            
            // Instantiate a button to be placed within the horizontally scrollable menu
            var scrollMenuButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
            
            // Obtain the title (i.e., diet name) to be displayed on the button.
            var buttonTitle = appDelegate.allDiets[i] as String
            
            var buttonTitleFont = UIFont(name: "Helvetica-Bold", size: 17.0)
            
            scrollMenuButton.titleLabel?.font = buttonTitleFont
            
            var buttonTitleSize: CGSize = (buttonTitle as NSString).sizeWithAttributes([NSFontAttributeName:buttonTitleFont!])
            
            // Leave 10 points on each size by adding 20 points to the total width
            scrollMenuButton.frame = CGRectMake(0.0, 0.0, buttonTitleSize.width + 20.0, kScrollMenuHeight)
            
            scrollMenuButton.backgroundColor = UIColor.blueColor()
            
            // Set the title of the button to the diet name
            scrollMenuButton.setTitle(buttonTitle, forState: UIControlState.Normal)
            
            // Set the button title color to white when the button is not selected.
            scrollMenuButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            // Set the button title to blue when the button is selectd
            scrollMenuButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Selected)
            
            // Set the background image to roundRect.png when a user selects the button
            scrollMenuButton.setBackgroundImage(UIImage(named: "roundRect.png"), forState: UIControlState.Selected)
            
            scrollMenuButton.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
            
            listOfMenuButtons.append(scrollMenuButton)
        }

        var sumOfButtonWidths: CGFloat = 0.0
        
        // Sets the x coordinates of each button properly spaced across the scroll view
        for var j = 0; j < listOfMenuButtons.count; j++ {
            
            var button: UIButton = listOfMenuButtons[j]
            
            var buttonRect: CGRect = button.frame
            
            buttonRect.origin.x = sumOfButtonWidths
            
            button.frame = buttonRect
            
            scrollMenu.addSubview(button)
            
            sumOfButtonWidths += button.frame.size.width
        }
        
        scrollMenu.contentSize = CGSizeMake(sumOfButtonWidths, kScrollMenuHeight)
        
        // Hide the left arrow by default (because scroll view is initially at x = 0)
        leftArrowWhite.hidden = true
        
        // Sets the default diet to the stored diet.
        var defaultIndex = 0
        
        for var i = 0; i < appDelegate.allDiets.count; i++ {
            
            if appDelegate.allDiets.objectAtIndex(i) as NSString == appDelegate.diet {
                
                defaultIndex = i
            }
        }
        
        var defaultButton: UIButton = listOfMenuButtons[defaultIndex]
        
        defaultButton.selected = true
        
        previousButton = defaultButton
        
        appDelegate.diet = appDelegate.allDiets.objectAtIndex(0) as String
    }
    
    // MARK: - Method to Handle Button Tap

    // This method is invoked when the user taps a button in the horizontally scrollable menu
    func buttonPressed(sender: UIButton) {
        
        var selectedButton: UIButton = sender
        
        selectedButton.selected = true
        
        if previousButton != selectedButton {
            // Selecting the selected button again should not change its title color
            previousButton.selected = false
        }
        
        previousButton = selectedButton
        
        appDelegate.diet = selectedButton.titleForState(UIControlState.Normal)!
    }
    
    @IBAction func cuisineSelectionPressed(sender: UIButton) {
        
        performSegueWithIdentifier("CuisineSelection", sender: self)
    }
    
    @IBAction func allergySelectionPressed(sender: UIButton) {
        
        performSegueWithIdentifier("AllergySelection", sender: self)
    }
    
    // MARK: - Scroll View Delegate Method
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        // Handles showing and hiding the left and right arrow depending on the current location in the scroll view displayed.
        
        if scrollView.contentOffset.x <= 5 {
            // Scrolling is done all the way to the RIGHT
            leftArrowWhite.hidden   = true      // Hide left arrow
            rightArrowWhite.hidden  = false     // Show right arrow
        }
        else if scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.frame.size.width) - 5 {
            // Scrolling is done all the way to the LEFT
            leftArrowWhite.hidden   = false     // Show left arrow
            rightArrowWhite.hidden  = true      // Hide right arrow
        }
        else {
            // Scrolling is in between. Scrolling can be done in either direction.
            leftArrowWhite.hidden   = false     // Show left arrow
            rightArrowWhite.hidden  = false     // Show right arrow
        }
    }
    
}
