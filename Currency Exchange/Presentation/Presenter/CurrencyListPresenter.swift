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
    
    var currencyList = [CurrencyModel]()
    
    init(view: CurrencyListViewController, interactor: CurrencyListInteractor) {
        self.view = view
        self.interactor = interactor
    }
    
    public func loadData() {
        interactor.getCurrencyList(success: { res in
            self.currencyList = res
            self.view?.reloadListView()
        }) { (err) in
        }
    }
}
