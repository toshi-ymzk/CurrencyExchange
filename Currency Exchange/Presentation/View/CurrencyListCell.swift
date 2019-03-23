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
    @IBOutlet var codeLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var amountTextField: UITextField!
    
    static let cellHeight: CGFloat = 100
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconView.backgroundColor = UIColor.lightGray
        iconView.layer.cornerRadius = iconView.bounds.width / 2
    }
    
    public func layout(currency: CurrencyModel) {
        iconView.image = currency.code.getNationalFlag()
        codeLabel.text = currency.code.rawValue
        nameLabel.text = currency.code.getCurrencyName()
        var text = "\(currency.amount)"
        // Cast to Int if the amount is integer
        if currency.amount.truncatingRemainder(dividingBy: 1.0) == 0.0 {
            text = "\(Int(currency.amount))"
        }
        amountTextField.text = text
    }
}
