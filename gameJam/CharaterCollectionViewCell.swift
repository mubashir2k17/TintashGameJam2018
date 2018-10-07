//
//  CharaterCollectionViewCell.swift
//  gameJam
//
//  Created by Tintash on 06/10/2018.
//  Copyright © 2018 Tintash. All rights reserved.
//

import UIKit

class CharaterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var playerNameLbl: UILabel!
    @IBOutlet weak var playerDiscriptionLbl: UILabel!
    @IBOutlet weak var powerDiscriptionLbl: UILabel!
    @IBOutlet weak var powerDiscription2lbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!


    var zoombieIdleImages = [UIImage]()
    var indexPath = IndexPath(item: -1, section: -1)


    override func awakeFromNib() {
        super.awakeFromNib()


        //imgView.image = animatedImage(asset: "zombieIdle", startIndex: 1, endIndex: 15)
        //imgView.image = animatedImage(asset: "robotIdle", startIndex: 0, endIndex: 8)
        //imgView.image = animatedImage(asset: "robotGoldenIdle", startIndex: 0, endIndex: 8)
        //mgView.image = animatedImage(asset: "trollGreenIdle", startIndex: 0, endIndex: 9, duration: 1)
        //imgView.image = animatedImage(asset: "trolIdle", startIndex: 0, endIndex: 6, duration: 0.7)

    }
    
    func setPlayer1() {
        playerNameLbl.text = "WomanWarrior"
        playerDiscriptionLbl.text = "Was it your dream?. Yes, your last. This murderous cold blooded beauty leaves no witnesses.".uppercased()
        powerDiscriptionLbl.text = "🛢 Hits 2 targets".uppercased()
        powerDiscription2lbl.text = "⏳ Does not die if enemy has the same up".uppercased()
        imgView.image = animatedImage(asset: "womanWarrior", startIndex: 0, endIndex: 4)
    }
    
    func setPlayer2() {
        playerNameLbl.text = "Knight"
        playerDiscriptionLbl.text = "He has got unbreakable faith, but not so breakable shield".uppercased()
        powerDiscriptionLbl.text = "🛢 15% to block any damage".uppercased()
        powerDiscription2lbl.text = "⏳ Armor gives you extra 1 +".uppercased()
        imgView.image = animatedImage(asset: "knightIdle", startIndex: 0, endIndex: 6)
    }
}

