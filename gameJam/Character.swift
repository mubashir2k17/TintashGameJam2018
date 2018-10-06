//
//  Character.swift
//  gameJam
//
//  Created by AbdurRafay on 06/10/2018.
//  Copyright © 2018 Tintash. All rights reserved.
//

import UIKit

class Character: CardView {

    var maxHealth = 10
    var maxARmor  = 8
    var currentHealth = 10
    var currentArmor = 0
    
    func addHealth(healthValue : Int) {
        currentHealth = min(currentHealth + healthValue, maxHealth)
    }
    
    func addArmor(armorValue : Int) {
        currentArmor = min(currentArmor + armorValue, maxARmor)
    }
}
