//
//  Meal.swift
//  Hacktech2018
//
//  Created by Ram Goli on 3/4/18.
//  Copyright © 2018 Deeptanshu. All rights reserved.
//

import UIKit

class Meal {
    var name: String;
    
    init?(name: String) {
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty  {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
    }
}
