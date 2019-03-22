//
//  CurrencyListCell.swift
//  Currency Exchange
//
//  Created by Toshihiro Nojima on 2019/03/22.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import UIKit

class CurrencyListCell: UIView {
    
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet var inputTextField: UITextField!
    
    static let cellHeight: CGFloat = 100
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconView.backgroundColor = UIColor.lightGray
        iconView.layer.cornerRadius = iconView.bounds.width / 2
    }
    
    public func layout(currency: CurrencyModel) {
        nameLabel.text = currency.name
    }
}
