//
//  ExchangeRateViewController.swift
//  PayBaymaxChallenge
//
//  Created by Tung Vu on 12/23/20.
//  Copyright © 2020 news. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ExchangeRateViewController: UIViewController {
    
    fileprivate var viewModel: ExRateViewModel              = injector.resolve(ExRateViewModel.self)!
    fileprivate let disposeBag: DisposeBag                  = DisposeBag()
    
    @IBOutlet private weak var btnSelectCurrency:           UIButton!
    @IBOutlet private weak var txtAmount:                   UITextField!
    @IBOutlet private weak var tbExchangeResult:            UITableView!
    @IBOutlet private weak var txtSelectedCurrency:         UILabel!
    
    fileprivate var currencySelectionSubject: PublishSubject  =  PublishSubject<CurrencyModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = bindingUserAction()
        let output = viewModel.transform(input, disposeBag: disposeBag)
        bindingTableView(output: output, tableView: self.tbExchangeResult)
        bindingErrorMessage(output: output)
        bindingIndicator(output: output)
    }
    
    // relese resource 
    deinit {
        currencySelectionSubject.onCompleted()
        currencySelectionSubject.dispose()
    }
}

extension ExchangeRateViewController {
    
    fileprivate func bindingTableView(output: ExRateViewModel.Output, tableView: UITableView) {
        // tableview datasource
        output
            .fetchLiveExRateSuccess
            .asObservable()
            .bind(to: tableView
                .rx
                .items(cellIdentifier: "ExCurrencyResultCell",
                       cellType: ExCurrencyResultCell.self))
            { _,currency,cell in
                cell.updateCell(currency: currency)
        }.disposed(by: disposeBag)
    }
    
    fileprivate func bindingUserAction() -> ExRateViewModel.Input {
        btnSelectCurrency
            .rx
            .tap
            .subscribe { _ in
                let vc = CurrenciesViewController.initViewController(with: CurrenciesViewController.identifier, nil, nil) as! CurrenciesViewController
                vc.currencySelectionResult = { [weak self] (currency) in
                    self?.currencySelectionSubject.onNext(currency)
                    self?.txtSelectedCurrency.text = currency.code
                    vc.dismiss(animated: true, completion: nil)
                }
                self.present(vc, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        return ExRateViewModel.Input(
            inputAmount: txtAmount
                .rx
                .text
                .asDriver(onErrorJustReturn: "0"),
            selectedCurrency: currencySelectionSubject
                .asDriver(onErrorJustReturn: CurrencyModel()))
        
    }
    
    fileprivate func bindingErrorMessage(output: ExRateViewModel.Output) {
        output
            .error
            .drive(onNext: { [weak self] (error) in
                self?.alert(message: error.errorMessage(), title: "Error!", action: {
                     self?.txtSelectedCurrency.text = "USD"
                })
            }).disposed(by: disposeBag)
    }
    
    fileprivate func bindingIndicator(output: ExRateViewModel.Output) {
        output
            .indicator
            .drive(onNext: { [weak self] (show) in
                self?.willShowProgressHud(show, onView: self?.view)
            }).disposed(by: disposeBag)
    }
}
