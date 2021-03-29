//
//  CurrenciesViewController.swift
//  PayBaymaxChallenge
//
//  Created by Tung Vu on 12/20/20.
//  Copyright © 2020 news. All rights reserved.
//

//import UIKit
import RxSwift
import RxCocoa

typealias CurrencySelectionResult = ((CurrencyModel) -> Void)

class CurrenciesViewController: BaseViewController {
    
    fileprivate var viewModel: CurrenciesViewModel      = injector.resolve(CurrenciesViewModel.self)!
    fileprivate let disposeBag: DisposeBag              = DisposeBag()
    
    @IBOutlet fileprivate weak var tbCurrency:  UITableView!
    @IBOutlet fileprivate weak var sbCurrency:  UISearchBar!
    @IBOutlet fileprivate weak var btnClose:    UIButton!
    
    var currencySelectionResult: CurrencySelectionResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindViewModel()
    }
    
    func bindViewModel() {
        let input = bindingUserAction()
        let output = viewModel.transform(input, disposeBag: disposeBag)
        bindingIndicator(output: output)
        bindingErrorMessage(output: output)
        bindingTableView(output: output, tableView: self.tbCurrency)
        
    }
}

// UI setup
extension CurrenciesViewController {
    
    fileprivate func bindingUserAction() -> CurrenciesViewModel.Input {
        // button close
        btnClose
            .rx
            .tap
            .subscribe { _ in
                self.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        self.sbCurrency
            .rx
            .searchButtonClicked
            .subscribe { [weak self] in
                self?.sbCurrency.resignFirstResponder()
        }.disposed(by: disposeBag)
        
        
        let input = CurrenciesViewModel.Input(
            
            fetchCurrenciesTrigger: Driver.just(()),
            
            selectedIndex: tbCurrency
                .rx
                .itemSelected
                .do (onNext: { indexPath in
                    self.tbCurrency.deselectRow(at: indexPath, animated: true)
                })
                .asDriverOnErrorJustComplete(),
            
            searchTextChanged: self.sbCurrency
                .rx
                .text
                .changed
                .map({ (text) -> String in
                    return (text ?? "")
                }).asDriver(onErrorJustReturn: "")
        )
        
        return input
    }
    
    fileprivate func bindingTableView(output: CurrenciesViewModel.Output, tableView: UITableView) {
        // tableview datasource
        output
            .fetchCurrenciesSuccess
            .asObservable()
            .bind(to: tableView
                .rx
                .items(cellIdentifier: "CurrencyViewCell",
                       cellType: CurrencyViewCell.self))
            { _,model,cell in
                cell.updateCell(model)
        }.disposed(by: disposeBag)
        
        // item selected
        output
            .selectedCurrency
            .drive(onNext: { [weak self] (currency) in
                self?.currencySelectionResult?(currency)
            }).disposed(by: disposeBag)
        
    }
    
    fileprivate func bindingErrorMessage(output: CurrenciesViewModel.Output) {
        output
            .error
            .drive(onNext: { [weak self] (error) in
                self?.alert(message: error.errorMessage(), title: "Error!", action: nil)
            }).disposed(by: disposeBag)
    }
    
    fileprivate func bindingIndicator(output: CurrenciesViewModel.Output) {
        output
            .indicator
            .drive(onNext: { [weak self] (show) in
                self?.willShowProgressHud(show, onView: self?.view)
            }).disposed(by: disposeBag)
    }
}

