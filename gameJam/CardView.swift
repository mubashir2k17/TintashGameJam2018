//
//  CardView.swift
//  gameJam
//
//  Created by AbdurRafay on 06/10/2018.
//  Copyright © 2018 Tintash. All rights reserved.
//

import UIKit

class CardView: UIView {

    @IBOutlet weak var cardBackgroundImageView: UIImageView!
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var armorLabel: UILabel!
    
    var position : (rowNum : Int, columnNum : Int) = (0,0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        if let viewsToAdd = Bundle.main.loadNibNamed("CardView", owner: self, options: nil), let viewToUse = viewsToAdd.first as? UIView {
            addSubview(viewToUse)
            viewToUse.frame = self.bounds
            viewToUse.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
    }
    
   
    func die(withCompletion completion:@escaping() -> Void) {
        UIView.animate(withDuration: 0.1,
                       delay: 0.2,
                       options: [.repeat, .autoreverse],
                       animations: {
                        UIView.setAnimationRepeatCount(2)
                        let transform = self.transform
                        self.transform = self.transform.rotated(by: 0.07)
                        self.transform = transform
        },
                       completion: { (true) in
                        UIView.animate(withDuration: 0.3,
                                       delay: 0.0,
                                       options: [.curveEaseInOut],
                                       animations: {
                                        let width = self.frame.size.width
                                        let heigth = self.frame.size.height
                                        let x = self.frame.origin.x
                                        let y = self.frame.origin.y
                                        self.frame = CGRect(x: x+10, y: y+10, width: width-20, height: heigth-20)
                                        self.alpha = 0.0
                        },
                                       completion: { (true) in
                                        completion()
                        })
        })
    }

    func moveToFrame() {
        
    }
    
    func moveLeft() {
        
    }
    
    func moveRight() {
        
    }
    
    func moveUp() {
        
    }
    
    func moveDown() {
        
    }
    
    @IBAction func cardTapAction(_ sender: Any) {
        die {
        }
    }
}
