//
//  UIView+.swift
//  CurrencyExchange
//
//  Created by Toshihiro Nojima on 2019/03/22.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import UIKit

extension UIView {
    
    func removeAllSubviews() {
        subviews.forEach { v in
            v.removeFromSuperview()
        }
    }
}

@IBDesignable
class DesignableView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let borderColor = self.layer.borderColor {
                return UIColor(cgColor: borderColor)
            } else {
                return nil
            }
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
}
