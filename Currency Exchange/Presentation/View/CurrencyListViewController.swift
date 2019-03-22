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
    
    lazy var presenter: CurrencyListPresenter = {
        // Dependency Injection
        let api: RevolutAPIProtocol = useStubData ? RevolutAPIStub() : RevolutAPI()
        let interactor = CurrencyListInteractor(api: api)
        return CurrencyListPresenter(view: self, interactor: interactor)
    }()
    
    @IBOutlet private var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.loadData()
    }
    
    public func reloadListView() {
        scrollView.removeAllSubviews()
        var y: CGFloat = 0
        for currency in presenter.currencyList {
            if let cell = Bundle.loadNib(CurrencyListCell.self) {
                cell.frame.size.width = UIScreen.width
                cell.frame.origin.y = y
                cell.layout(currency: currency)
                scrollView.addSubview(cell)
                y += cell.bounds.height
            }
        }
        scrollView.contentSize = CGSize(width: UIScreen.width, height: y)
    }
}

