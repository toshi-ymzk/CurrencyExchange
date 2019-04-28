//
//  NSObject+.swift
//  CurrencyExchange
//
//  Created by Toshihiro Nojima on 2019/04/28.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import Foundation

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}
