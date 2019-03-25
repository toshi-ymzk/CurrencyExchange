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
    
    init(view: CurrencyListViewController?, interactor: CurrencyListInteractor, router: CurrencyListRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    public func viewDidLoad() {
        getCurrencyList()
    }
    
    @objc private func getCurrencyList() {
        interactor.getCurrencyList(baseAmount: baseAmount, success: { [weak self] res in
            guard let s = self else { return }
            s.currencyList = res
            s.view?.setupListCells()
            Timer.scheduledTimer(timeInterval: 1.0, target: s, selector: #selector(s.getCurrencyRates), userInfo: nil, repeats: true)
        }) { (err) in
        }
    }
    
    @objc private func getCurrencyRates() {
        interactor.getCurrencyRates(success: { [weak self] res in
            guard let s = self else { return }
            s.updateCurrencyRates(rates: res)
            s.view?.updateListCells()
        }) { (err) in
        }
    }
    
    private func updateCurrencyRates(rates: [Double]) {
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
    
    public func didInputAmount(amount: String, index: Int) {
        selectedIndex = index
        guard let currency = currencyList[safe: index],
            let amount = Double(amount) else {
            return
        }
        currency.amount = amount
        baseAmount = (amount / currency.rate).truncate(CurrencyModel.maxDicimalPlaces)
    }
}
