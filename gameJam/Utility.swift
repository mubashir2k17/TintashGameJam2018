//
//  Utility.swift
//  gameJam
//
//  Created by khunshan on 06/10/2018.
//  Copyright © 2018 Tintash. All rights reserved.
//

import UIKit

func animatedImage(asset: String, startIndex: Int, endIndex: Int, duration: Double = 1) -> UIImage? {
    
    var arr = [UIImage]()
    
    for i in startIndex...endIndex {
        let filename = "\(asset)\(i)"
        arr.append(UIImage(named: filename)!)
    }
    
    let image = UIImage.animatedImage(with: arr, duration: duration)
    return image
    
}
