//
//  CurrencyListPresenter.swift
//  Currency Exchange
//
//  Created by Toshihiro Nojima on 2019/03/22.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import Foundation

class CurrencyListPresenter {
    
    weak var view: CurrencyListViewController?
    let interactor: CurrencyListInteractor
    let router: CurrencyListRouter
    
    var currencyList = [CurrencyModel]()
    
    var selectedIndex = 0
    
    var baseAmount: Double = 0.0 {
        didSet {
            for (i, currency) in currencyList.enumerated() {
                if i == selectedIndex { continue }
                currency.amount = (baseAmount * currency.rate).truncate(CurrencyModel.maxDicimalPlaces)
            }
        }
    }
    
    var timer: Timer?
    
    init(view: CurrencyListViewController?, interactor: CurrencyListInteractor, router: CurrencyListRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        getCurrencyList()
    }
    
    func getCurrencyList() {
        interactor.getCurrencyList(baseAmount: baseAmount, success: { [weak self] res in
            guard let s = self else { return }
            s.currencyList = res
            s.view?.setupListCells()
            s.timer = Timer.scheduledTimer(timeInterval: 1.0, target: s, selector: #selector(s.getCurrencyRates), userInfo: nil, repeats: true)
        }) { (err) in
        }
    }
    
    @objc func getCurrencyRates() {
        interactor.getCurrencyRates(success: { [weak self] res in
            guard let s = self else { return }
            s.updateCurrencyRates(rates: res)
            s.view?.updateListCells()
        }) { (err) in
        }
    }
    
    func updateCurrencyRates(rates: [Double]) {
        guard currencyList.count == rates.count else {
            return
        }
        for (i, currency) in currencyList.enumerated() {
            let rate = rates[i]
            currency.rate = rate
            if i == selectedIndex { continue }
            currency.amount = (baseAmount * rate).truncate(CurrencyModel.maxDicimalPlaces)
        }
    }
    
    func setBaseAmount(amount: Double, index: Int) {
        selectedIndex = index
        guard let currency = currencyList[safe: index] else { return }
        currency.amount = amount
        baseAmount = (amount / currency.rate).truncate(CurrencyModel.maxDicimalPlaces)
    }
    
    func didChangeText(_ text: inout String) -> String {
        let hasPoint = text.contains(".")
        if text.isEmpty {
            text = "0"
        // In case increment from 0
        } else if text.count > 1, !hasPoint, let firstChar = text.first, firstChar == "0" {
            text.remove(at: text.startIndex)
        }
        return text
    }
    
    func shouldChangeText(_ text: String, replacement: String) -> Bool {
        let isPoint = replacement == "."
        let hasPoint = text.contains(".")
        let dicimalPlaces = hasPoint ? text.split(separator: ".")[safe: 1]?.count ?? 0 : 0
        let digit = hasPoint ? text.split(separator: ".")[0].count : text.count
        // Check decimal point
        if isPoint, hasPoint {
            return false
        // Check decimal places
        } else if !replacement.isEmpty, dicimalPlaces >= CurrencyModel.maxDicimalPlaces {
            return false
        // Check max digit
        } else if !replacement.isEmpty, digit >= CurrencyModel.maxDigit, !isPoint, !hasPoint {
            return false
        }
        return true
    }
}
