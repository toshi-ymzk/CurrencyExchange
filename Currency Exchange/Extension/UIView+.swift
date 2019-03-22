//
//  UIView+.swift
//  Currency Exchange
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
