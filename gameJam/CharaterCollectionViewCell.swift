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
        imgView.image = animatedImage(asset: "robotGoldenIdle", startIndex: 0, endIndex: 8)
    }
}

