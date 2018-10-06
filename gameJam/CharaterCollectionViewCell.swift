//
//  CharaterCollectionViewCell.swift
//  gameJam
//
//  Created by Tintash on 06/10/2018.
//  Copyright © 2018 Tintash. All rights reserved.
//

import UIKit

class CharaterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    var zoombieIdleImages = [UIImage]()
    
    override func awakeFromNib() {
        super.awakeFromNib()

        //imgView.image = animatedImage(asset: "zombieIdle", startIndex: 1, endIndex: 15)
        //imgView.image = animatedImage(asset: "robotIdle", startIndex: 0, endIndex: 8)
        //imgView.image = animatedImage(asset: "robotGoldenIdle", startIndex: 0, endIndex: 8)
        imgView.image = animatedImage(asset: "trollGreenIdle", startIndex: 0, endIndex: 9, duration: 1)

    }

}

