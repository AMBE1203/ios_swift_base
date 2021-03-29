//
//  CurrenciesViewModel.swift
//  PayBaymaxChallenge
//
//  Created by Tung Vu on 12/20/20.
//  Copyright © 2020 news. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


struct CurrenciesViewModel {
    
    private var getCurrenciesUsecase:   GetAllCurrencyUseCase
    
    init(usecase: GetAllCurrencyUseCase) {
        self.getCurrenciesUsecase = usecase
    }
}


extension CurrenciesViewModel: BaseViewModel {
    
    struct Input {
        let fetchCurrenciesTrigger:         Driver<Void>
        var selectedIndex:                  Driver<IndexPath>
        var searchTextChanged:              Driver<String>
    }
    
    struct Output {
        var indicator:                      Driver<Bool>
        var fetchCurrenciesSuccess:         Driver<[CurrencyModel]>
        var error:                          Driver<Error>
        var selectedCurrency:               Driver<CurrencyModel>
    }
    
    
    func transform(_ input: CurrenciesViewModel.Input, disposeBag: DisposeBag) -> CurrenciesViewModel.Output {
        let indicator = ActivityIndicator()
        let error = ErrorTracker()
        
        let fetchedCurrencies = input.fetchCurrenciesTrigger
            .flatMapLatest { (_) -> Driver<[CurrencyModel]> in
                return self.getCurrenciesUsecase
                    .execute()
                    .trackActivity(indicator)
                    .trackError(error)
                    .asDriver(onErrorJustReturn: [])
        }
        let currencies = Driver
            .combineLatest(input.searchTextChanged.startWith(""),
                           fetchedCurrencies)
            .map { (inputText, items) -> [CurrencyModel] in
                return items.filter { (item) -> Bool in
                    return (inputText == ""
                        || item.name.lowercased().contains(inputText.lowercased())
                        || item.code.lowercased().contains(inputText.lowercased()))
                }
        }.asDriver()
        
        //        let currencies = input
        //            .searchTextChanged
        //            .startWith("")
        //            .withLatestFrom(fetchedCurrencies) { (inputText, items) -> [CurrencyModel] in
        //                return items.filter { (item) -> Bool in
        //                    return (inputText == ""
        //                        || item.name.lowercased().contains(inputText.lowercased())
        //                        || item.code.lowercased().contains(inputText.lowercased()))
        //                }
        //        }.asDriver()
        
        let selected =
            input.selectedIndex
                .withLatestFrom(currencies) {
                    (index, items) -> CurrencyModel in
                    return items[index.row]
            }.asDriver()
        
        return Output(indicator: indicator.asDriver(),
                      fetchCurrenciesSuccess: currencies,
                      error: error.asDriver(),
                      selectedCurrency: selected)
        
    }
    
}
