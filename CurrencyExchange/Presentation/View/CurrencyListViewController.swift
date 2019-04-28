//
//  CurrencyListViewController.swift
//  CurrencyExchange
//
//  Created by Toshihiro Nojima on 2019/03/21.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import UIKit

class CurrencyListViewController: UIViewController {
    
    lazy var presenter = CurrencyListRouter(view: self).inject()
    
    @IBOutlet private var headerView: UIView!
    @IBOutlet private var headerViewHeight: NSLayoutConstraint!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var errorView: UIView!
    @IBOutlet private var reloadButton: UIView!
    
    let headerCell: CurrencyListCell? = Bundle.loadNib(CurrencyListCell.self)
    
    let formatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.loadData()
    }
    
    private func setupViews() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
        let nib = UINib(nibName: CurrencyListCell.className, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: CurrencyListCell.className)
        tableView.delaysContentTouches = false
        tableView.alpha = 0
        
        reloadButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reload)))
        
        headerViewHeight.constant = CurrencyListCell.cellHeight + 1 // Border height
        headerView.alpha = 0
        if let headerCell = headerCell {
            headerView.addSubview(headerCell)
            headerView.sendSubviewToBack(headerCell)
            headerCell.pinEdgesToSuperviewEdges()
            headerCell.amountTextField.delegate = self
            headerCell.amountTextField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.tableView.alpha = 1
            })
        }
    }
    
    func updateCells() {
        DispatchQueue.main.async {
            for cell in self.tableView.visibleCells {
                guard let index = self.tableView.indexPath(for: cell),
                    let currency = self.presenter.currencyList[safe: index.row] else {
                        return
                }
                (cell as? CurrencyListCell)?.layout(currency: currency)
            }
        }
    }
    
    func reloadHeader() {
        guard let selectedCurrency = self.presenter.currencyList[safe: self.presenter.selectedIndex] else {
            return
        }
        DispatchQueue.main.async {
            self.headerCell?.layout(currency: selectedCurrency)
            self.headerCell?.amountTextField.becomeFirstResponder()
            self.headerCell?.isActive = true
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.headerView.alpha = 1
            })
        }
    }
    
    private func animateCell(selectedIndex: Int) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: selectedIndex, section: 0)),
            let animateCell: CurrencyListCell = Bundle.loadNib(CurrencyListCell.self),
            let selectedCurrency = self.presenter.currencyList[safe: self.presenter.selectedIndex] else {
                return
        }
        cell.alpha = 0
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.headerCell?.alpha = 0
        }, completion: { _ in
            self.reloadHeader()
        })
        animateCell.layout(currency: selectedCurrency)
        animateCell.frame = cell.convert(cell.bounds, to: self.headerView)
        self.headerView.addSubview(animateCell)
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            animateCell.frame.origin.y = 0
        }, completion: { _ in
            self.headerCell?.alpha = 1
            animateCell.removeFromSuperview()
        })
    }
    
    func showErrorView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.errorView.alpha = 1
        })
    }
    
    @objc func reload() {
        errorView.alpha = 0
        presenter.loadData()
    }
    
    @objc private func resignTextField() {
        headerCell?.amountTextField.resignFirstResponder()
    }
}

extension CurrencyListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        resignTextField()
    }
}

extension CurrencyListViewController: UITextFieldDelegate {
    
    @objc func editingChanged(_ textField: UITextField) {
        guard var text = textField.text?.replacingOccurrences(of: ",", with: "") else {
            return
        }
        text = presenter.didChangeText(&text)
        let amount = Double(text) ?? 0
        textField.text = formatter.addDecimalComma(str: text)
        textField.textColor = amount == 0 ? UIColor.lightGray : UIColor.hexColor(0x111111)
        presenter.setBaseAmount(amount: amount)
        updateCells()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text?.replacingOccurrences(of: ",", with: "") else {
            return false
        }
        return presenter.shouldChangeText(text, replacement: string)
    }
}

extension CurrencyListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.currencyList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == presenter.selectedIndex {
            return 0
        }
        return CurrencyListCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyListCell.className, for: indexPath) as? CurrencyListCell,
        let currency = presenter.currencyList[safe: indexPath.row] else {
            return tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
        }
        cell.layout(currency: currency)
        cell.amountTextField.isUserInteractionEnabled = false
        cell.isHidden = indexPath.row == presenter.selectedIndex
        return cell
    }
}

extension CurrencyListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndex = IndexPath(row: presenter.selectedIndex, section: 0)
        presenter.selectedIndex = indexPath.row
        animateCell(selectedIndex: indexPath.row)
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath, previousIndex], with: .fade)
        tableView.endUpdates()
    }
}
