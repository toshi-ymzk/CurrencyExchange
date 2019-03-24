//
//  CurrencyListRouter.swift
//  Currency Exchange
//
//  Created by Toshihiro Nojima on 2019/03/24.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import UIKit

class CurrencyListRouter {
    
    var useStubData = true
    
    weak var view: CurrencyListViewController?
    
    init(view: CurrencyListViewController) {
        self.view = view
    }
    
    func inject() -> CurrencyListPresenter {
        let api: RevolutAPIProtocol = useStubData ? RevolutAPIStub() : RevolutAPI()
        let interactor = CurrencyListInteractor(api: api)
        let presenter = CurrencyListPresenter(view: view, interactor: interactor, router: self)
        view?.presenter = presenter
        return presenter
    }
}
