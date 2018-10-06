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

    override init(frame: CGRect) {
        super.init(frame: frame)
        super.cardBackgroundImageView.image = animatedImage(asset: "knightIdle", startIndex: 0, endIndex: 6)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addHealth(healthValue : Int) {
        currentHealth = min(currentHealth + healthValue, maxHealth)
    }
    
    func addArmor(armorValue : Int) {
        currentArmor = min(currentArmor + armorValue, maxARmor)
    }
}
