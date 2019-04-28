//
//  CurrencyListPresenter.swift
//  CurrencyExchange
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
    
    func loadData() {
        getCurrencyList()
    }
    
    func getCurrencyList() {
        DispatchQueue.global(qos: .utility).async {
            self.interactor.getCurrencyList(base: "AUD", baseAmount: self.baseAmount, success: { [weak self] res in
                self?.currencyList = res
                self?.view?.reloadHeader()
                self?.view?.reloadTableView()
                self?.setUpdateRatesTimer()
            }) { [weak self] err in
                // Show reload button in case initial loading fails
                self?.view?.showErrorView()
            }
        }
    }
    
    func setUpdateRatesTimer() {
        guard timer == nil else {
            return
        }
        weak var weakSelf = self
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: weakSelf as Any, selector: #selector(getCurrencyRates), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        self.timer = timer
    }
    
    @objc func getCurrencyRates() {
        guard let selectedCurrency = currencyList[safe: selectedIndex] else {
            return
        }
        DispatchQueue.global(qos: .utility).async {
            self.interactor.getCurrencyRates(base: selectedCurrency.code.rawValue, success: { [weak self] res in
                self?.updateCurrencyRates(rates: res)
                self?.view?.updateCells()
            }) { _ in
                // Do nothing for update failure
            }
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
    
    func setBaseAmount(amount: Double) {
        guard let currency = currencyList[safe: selectedIndex] else { return }
        currency.amount = amount
        baseAmount = amount
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
