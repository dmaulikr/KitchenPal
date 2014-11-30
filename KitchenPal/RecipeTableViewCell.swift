//
//  RecipeTableViewCell.swift
//  KitchenPal
//
//  Created by Michael Zamani on 11/24/14.
//  Copyright (c) 2014 Michael Zamani. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var recipeName: UILabel!
    //@IBOutlet var recipeCourses: UILabel!
    @IBOutlet var recipeRating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
