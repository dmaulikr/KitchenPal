//
//  DietCuisineViewController.swift
//  KitchenPal
//
//  Created by Michael Zamani on 12/2/14.
//  Copyright (c) 2014 Michael Zamani. All rights reserved.
//

import UIKit

class DietCuisineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var leftArrowWhite: UIImageView!
    @IBOutlet var rightArrowWhite: UIImageView!
    @IBOutlet var cuisinesTableView: UITableView!
    
    // References to the Storyboard objects
    @IBOutlet var scrollMenu: UIScrollView!
    
    // Other properties (instance variables) and their initializations
    let kScrollMenuHeight: CGFloat = 30.0
    var previousButton = UIButton(frame: CGRectMake(0, 0, 0, 0))
    
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addCuisine:")
        self.navigationItem.rightBarButtonItem = addButton
        
        // Must manually link editing button to edit table view action. 
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
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
    
    // MARK: - Scroll View Delegate Method
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        // If the selected scrollView is the cuisinesTableView, return from the function.
        if scrollView == cuisinesTableView {
            return
        }
        
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
    
    // MARK: - Add Cuisine Method
    
    func addCuisine(sender: AnyObject) {
        
        if !noCuisinesRemaining() {
            
            // Perform a segue to the AddCuisineViewController
            performSegueWithIdentifier("AddCuisine", sender: self)
        } else {
            
            var alertView = UIAlertView()
            
            alertView.title = "No Cuisines Remain!"
            alertView.message = "There are no cuisines remaining to be added."
            alertView.addButtonWithTitle("OK")
            alertView.delegate = nil
            
            alertView.show()
        }
        
    }
    
    // MARK: - Set Editing Method
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        cuisinesTableView.setEditing(editing, animated: animated)
    }
    
    // MARK: - Data validation
    
    func noCuisinesRemaining() -> Bool {
        
        // If the count of the cuisines and allCuisines array are equivalent, no cuisines remain.
        return appDelegate.cuisines.count == appDelegate.allCuisines.count
    }
    
    // MARK: - Table view data source
    
    // Returns the number of sections in the TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    // Returns the number of rows (or already selected cuisines)
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return appDelegate.cuisines.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CuisineCell", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        cell.textLabel!.text = appDelegate.cuisines[indexPath.row] as? String
        
        return cell
    }
    
    // We allow each row (cuisine) of the table view to be editable, i.e., deletable.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    // This method is invoked when the user taps the Delete button in the Edit mode.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete { // Delete the cuisine.
            
            appDelegate.cuisines.removeObjectAtIndex(indexPath.row)
        }
        cuisinesTableView.reloadData()
    }
    
    // MARK: - Unwind Segue method
    
    @IBAction func unwindToDietCuisineTableViewController(segue: UIStoryboardSegue) {
        
        if segue.identifier == "AddCuisine-Save" {
            
            var controller: AddCuisineViewController = segue.sourceViewController as AddCuisineViewController
            
            if controller.isKindOfClass(AddCuisineViewController) {
                
                var newCuisineName: String = controller.cuisineToAdd
                
                appDelegate.cuisines.addObject(newCuisineName)
                
                cuisinesTableView.reloadData()
            }
            
        }
    }
    
}
