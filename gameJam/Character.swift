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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupCard(params: (assetName: String, startIndex: Int, endIndex: Int)) {
        
        cardBackgroundImageView.image = animatedImage(asset: params.assetName, startIndex: params.startIndex, endIndex: params.endIndex)
        healthLabel.text = String(currentHealth)
        armorLabel.text = String(currentArmor)
    }

    func addHealth(healthValue : Int) {
        currentHealth = max(min(currentHealth + healthValue, maxHealth),0)
        self.healthLabel.text = String(currentHealth)
    }
    
    func addArmor(armorValue : Int) {
        currentArmor = max(min(currentArmor + armorValue, maxARmor),0)
        self.armorLabel.text = String(currentArmor)
    }
}
