//
//  CurrencyListCell.swift
//  CurrencyExchange
//
//  Created by Toshihiro Nojima on 2019/03/22.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import UIKit

class CurrencyListCell: UITableViewCell {
    
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var codeLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var textFieldBorder: UIView!
    
    static let cellHeight: CGFloat = 100
    static let maxDicimalPlaces = 3
    static let maxDigit = 9
    
    var isActive = false {
        didSet {
            textFieldBorder.backgroundColor = isActive ? UIColor.hexColor(0x0D7AFF) : UIColor.hexColor(0xEFEFF4)
        }
    }
    
    let formatter = NumberFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        iconView.backgroundColor = UIColor.lightGray
        iconView.layer.cornerRadius = iconView.bounds.width / 2
    }
    
    public func layout(currency: CurrencyModel) {
        iconView.image = currency.code.getNationalFlag()
        codeLabel.text = currency.code.rawValue
        nameLabel.text = currency.code.getCurrencyName()
        symbolLabel.text = currency.code.getSymbol()
        var text = "\(currency.amount)"
        // Cast to Int if the amount is integer
        if currency.amount.truncatingRemainder(dividingBy: 1.0) == 0.0, currency.amount <= Double(Int.max) {
            text = "\(Int(currency.amount))"
        }
        amountTextField.text = formatter.addDecimalComma(str: text)
        amountTextField.textColor = currency.amount == 0 ? UIColor.lightGray : UIColor.hexColor(0x111111)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if isActive { return }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if isActive { return }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = .identity
        })
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if isActive { return }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = .identity
        })
    }
}
