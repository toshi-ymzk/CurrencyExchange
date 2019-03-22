//
//  Bundle+.swift
//  Currency Exchange
//
//  Created by Toshihiro Nojima on 2019/03/22.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import Foundation

extension Bundle {
    
    static func loadNib<T>(_ type: T.Type) -> T? {
        if let t = main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?.first as? T {
            return t
        }
        return nil
    }
}
