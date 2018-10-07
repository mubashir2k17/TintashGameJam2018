//
//  Extensions.swift
//  gameJam
//
//  Created by Tintash on 06/10/2018.
//  Copyright © 2018 Tintash. All rights reserved.
//

import Foundation
import UIKit
extension UIView {

    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.4
            layer.shadowRadius = shadowRadius
        }
    }
}

extension CALayer {
    func addGradienBorder(colors:[UIColor],width:CGFloat = 1, radius:CGFloat = 0) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame =  CGRect(origin: .zero, size: self.bounds.size)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = colors.map({$0.cgColor})
        gradientLayer.cornerRadius = radius

        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        let path = UIBezierPath(rect: gradientLayer.frame).cgPath
        shapeLayer.path = path
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.cornerRadius = radius

        gradientLayer.mask = shapeLayer

        self.addSublayer(gradientLayer)
    }
    
}
