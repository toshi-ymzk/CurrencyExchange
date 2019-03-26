//
//  CurrencyListViewController.swift
//  Currency Exchange
//
//  Created by Toshihiro Nojima on 2019/03/21.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import UIKit

class CurrencyListViewController: UIViewController {
    
    lazy var presenter = CurrencyListRouter(view: self).inject()
    
    @IBOutlet private var headerView: UIView!
    @IBOutlet private var headerViewHeight: NSLayoutConstraint!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var blockView: UIView! // View to block user interaction while animating
    
    private var listCells = [CurrencyListCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        headerViewHeight.constant = CurrencyListCell.cellHeight + 1 // Border height
        scrollView.delaysContentTouches = false
    }
    
    public func setupListCells() {
        scrollView.removeAllSubviews()
        var y: CGFloat = 0
        for (i, currency) in presenter.currencyList.enumerated() {
            if let cell = Bundle.loadNib(CurrencyListCell.self) {
                cell.frame.size.width = UIScreen.width
                cell.frame.origin.y = y
                cell.tag = i
                cell.layout(currency: currency)
                cell.amountTextField.delegate = self
                cell.amountTextField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
                cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectCell)))
                scrollView.addSubview(cell)
                listCells.append(cell)
                y += cell.bounds.height
            }
        }
        scrollView.contentSize = CGSize(width: UIScreen.width, height: y)
        replaceCells(selectedIndex: 0)
    }
    
    public func updateListCells() {
        for (i, cell) in listCells.enumerated() {
            if i == presenter.selectedIndex { continue }
            if let currency = self.presenter.currencyList[safe: i] {
                cell.layout(currency: currency)
            }
        }
    }
    
    @objc private func didSelectCell(_ gesture: UITapGestureRecognizer) {
        guard let cell = gesture.view as? CurrencyListCell else {
            return
        }
        replaceCells(selectedIndex: cell.tag)
    }
    
    private func replaceCells(selectedIndex: Int) {
        guard let previousCell = self.listCells[safe: presenter.selectedIndex],
            let selectedCell = self.listCells[safe: selectedIndex] else {
            return
        }
        presenter.selectedIndex = selectedIndex
        if previousCell.amountTextField.isFirstResponder {
            previousCell.amountTextField.resignFirstResponder()
        }
        
        previousCell.frame.origin.y = previousCell.convert(previousCell.bounds, to: self.scrollView).origin.y
        previousCell.removeFromSuperview()
        scrollView.addSubview(previousCell)
        
        selectedCell.frame.origin.y = selectedCell.convert(selectedCell.bounds, to: self.headerView).origin.y
        selectedCell.transform = .identity
        selectedCell.removeFromSuperview()
        self.headerView.addSubview(selectedCell)
        
        blockView.isHidden = false
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            for (i, cell) in self.listCells.enumerated() {
                if i == selectedIndex {
                    selectedCell.frame.origin.y = 0
                    selectedCell.isSelected = true
                } else {
                    let index = i < selectedIndex ? i + 1 : i
                    cell.frame.origin.y = cell.bounds.height * CGFloat(index)
                    cell.isSelected = false
                }
            }
        }, completion: { _ in
            self.blockView.isHidden = true
            selectedCell.amountTextField.becomeFirstResponder()
        })
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
        text = presenter.didChangeText(&text)
        let amount = Double(text) ?? 0
        let index = textField.superview?.tag ?? 0
        textField.text = text
        textField.textColor = amount == 0 ? UIColor.lightGray : UIColor.hexColor(0x111111)
        presenter.setBaseAmount(amount: amount, index: index)
        updateListCells()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let index = textField.superview?.tag ?? 0
        replaceCells(selectedIndex: index)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return false
        }
        return presenter.shouldChangeText(text, replacement: string)
    }
}
