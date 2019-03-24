//
//  CurrencyListViewController.swift
//  Currency Exchange
//
//  Created by Toshihiro Nojima on 2019/03/21.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import UIKit

class CurrencyListViewController: UIViewController {
    
    var useStubData = true
    
    lazy var presenter = CurrencyListRouter(view: self).inject()
    
    @IBOutlet private var scrollView: UIScrollView!
    
    private var listCells = [CurrencyListCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignTextField)))
    }
    
    public func setupListCells() {
        scrollView.removeAllSubviews()
        var y: CGFloat = 0
        for (i, currency) in presenter.currencyList.enumerated() {
            if let cell = Bundle.loadNib(CurrencyListCell.self) {
                cell.frame.size.width = UIScreen.width
                cell.frame.origin.y = y
                cell.layout(currency: currency)
                cell.amountTextField.delegate = self
                cell.amountTextField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
                cell.amountTextField.tag = i
                scrollView.addSubview(cell)
                listCells.append(cell)
                y += cell.bounds.height
            }
        }
        scrollView.contentSize = CGSize(width: UIScreen.width, height: y)
    }
    
    public func updateListCells() {
        for (i, cell) in self.listCells.enumerated() {
            if let currency = self.presenter.currencyList[safe: i] {
                cell.layout(currency: currency)
            }
        }
    }
    
    @objc private func resignTextField() {
        listCells.forEach {
            if $0.amountTextField.isFirstResponder {
                $0.amountTextField.resignFirstResponder()
            }
        }
    }
}

extension CurrencyListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        resignTextField()
    }
}

extension CurrencyListViewController: UITextFieldDelegate {
    
    @objc func editingChanged(_ textField: UITextField) {
        guard var text = textField.text else {
            return
        }
        let hasPoint = text.contains(".")
        if text.isEmpty {
            text = "0"
        } else if text.count > 1, !hasPoint, let firstChar = text.first, firstChar == "0" {
            text.remove(at: text.startIndex)
        }
        textField.text = text
        presenter.didInputAmount(amount: text, index: textField.tag)
        updateListCells()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // TODO: Move cell
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return false
        }
        let isPoint = string == "."
        let hasPoint = text.contains(".")
        if isPoint, hasPoint {
            return false
        }
        return true
    }
}
