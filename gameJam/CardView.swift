//
//  CardView.swift
//  gameJam
//
//  Created by AbdurRafay on 06/10/2018.
//  Copyright © 2018 Tintash. All rights reserved.
//

import UIKit

class CardView: UIView {

    @IBOutlet weak var cardItemImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var armorLabel: UILabel!
    
    var position : (rowNum : Int, columnNum : Int) = (0,0)
    var health = 0
    var armor = 0
    var cardType : CardType = .Enemy
    var cardDidPress: ((CardView)->Void)? = nil
    
    var cardItemImageViewHiddenValue = false
    var healthLblHiddenValue = false
    var armorLblHiddenValue = false

    convenience init(frame: CGRect, cardDidPress: ((CardView)->Void)?) {
        self.init(frame: frame)
        self.cardDidPress = cardDidPress
    }

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
            backgroundImageView.clipsToBounds = true
            cardItemImageView.contentMode = .scaleAspectFit
        }
    }
    
    func die(withCompletion completion:@escaping() -> Void) {
        UIView.animate(withDuration: 0.1,
                       delay: 0.2,
                       options: [.repeat, .autoreverse],
                       animations: {
                        UIView.setAnimationRepeatCount(2)
                        let transform = self.transform
                        self.transform = self.transform.rotated(by: 0.05)
                        self.transform = transform
        },
                       completion: { (true) in
                        UIView.animate(withDuration: 0.3,
                                       delay: 0.0,
                                       options: [.curveEaseInOut],
                                       animations: {
//                                        let width = self.frame.size.width
//                                        let heigth = self.frame.size.height
//                                        let x = self.frame.origin.x
//                                        let y = self.frame.origin.y
//                                        self.frame = CGRect(x: x+10, y: y+10, width: width-20, height: heigth-20)
                                        self.alpha = 0.0
                        },
                                       completion: { (true) in
                                        self.removeFromSuperview()
                                        completion()
                        })
        })
    }

    func move(toOrigin origin : CGPoint, completion: (()->())? = nil) {
        UIView.animate(withDuration: 0.4,
                       delay: 0.0,
                       options: [.curveEaseInOut],
                       animations: {
                        self.frame.origin = origin
        },
                       completion: { (true) in
                        if let comp = completion {
                            comp()
                        }
        })
    }
    
    @IBAction func cardTapAction(_ sender: Any) {
        cardDidPress?(self)
    }

    func setupCard(params: (assetName: String, startIndex: Int, endIndex: Int), hover: Bool = false, insets: UIEdgeInsets = .zero) {
        // change cardBackgroundImageView to image and set background image seperately
        cardItemImageView.image = animatedImage(asset: params.assetName, startIndex: params.startIndex, endIndex: params.endIndex)?.withAlignmentRectInsets(insets)
        if(health == 0) {
            healthLabel.isHidden = true
        }
        else {
            self.healthLabel.text = String(abs(health))
        }
        
        if(armor == 0) {
            armorLabel.isHidden = true
        }
        else {
            self.armorLabel.text = String(armor)
        }
        
        if(cardType == .Gold) {
            self.healthLabel.backgroundColor = UIColor(red: 255/255.0, green: 215/255.0, blue: 0, alpha: 1)
        }
        hoverItemImageView(animate: hover)
    }
    
    func setHealth() {
        self.healthLabel.text = String(abs(health))
    }
    
    func hideCard() {
        
        cardItemImageViewHiddenValue = cardItemImageView.isHidden
        healthLblHiddenValue = armorLabel.isHidden
        armorLblHiddenValue = healthLabel.isHidden
        
        cardItemImageView.isHidden = true
        armorLabel.isHidden = true
        healthLabel.isHidden = true
    }
    
    func showCard() {

        cardItemImageView.isHidden = cardItemImageViewHiddenValue
        armorLabel.isHidden = healthLblHiddenValue
        healthLabel.isHidden = armorLblHiddenValue
    }
    
    //Flip Card
    func flipCardItemImageView(flip: Bool) {
        cardItemImageView.transform = flip ? CGAffineTransform(scaleX: -1, y: 1) : .identity
    }
    
    //Hover animation
    func hoverItemImageView(animate: Bool) {
        
        let randomDelay = (arc4random_uniform(250)/100) + 1

        if animate {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(randomDelay)) {
                let hover = CABasicAnimation(keyPath: "position")
                hover.isAdditive = true
                hover.fromValue = NSValue(cgPoint: CGPoint.zero)
                hover.toValue = NSValue(cgPoint: CGPoint(x: 0.0, y: 15.0))
                hover.autoreverses = true
                hover.duration = 2
                hover.repeatCount = Float.infinity
                self.cardItemImageView.layer.add(hover, forKey: "myHoverAnimation")
            }
        }
        else {
            cardItemImageView.layer.removeAnimation(forKey: "myHoverAnimation")
        }
        
    }
}
