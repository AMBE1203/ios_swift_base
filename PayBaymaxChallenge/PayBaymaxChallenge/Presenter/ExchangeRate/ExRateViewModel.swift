//
//  ExRateViewModel.swift
//  PayBaymaxChallenge
//
//  Created by Tung Vu on 12/23/20.
//  Copyright © 2020 news. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ExRateViewModel {
    private var fetchLiveExRateUseCase: GetExchangeRateUseCase
    
    init(usecase: GetExchangeRateUseCase) {
        self.fetchLiveExRateUseCase = usecase
    }
}

extension ExRateViewModel: BaseViewModel {
    
    struct Input {
        var inputAmount:                        Driver<String?>
        var selectedCurrency:                   Driver<CurrencyModel>
    }
    
    struct Output {
        var indicator:                          Driver<Bool>
        var fetchLiveExRateSuccess:             Driver<[ExchangeCurrencyModel]>
        var error:                              Driver<Error>
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let indicator = ActivityIndicator()
        let error = ErrorTracker()
        
        let exRate = input.selectedCurrency
            .startWith(CurrencyModel())
            .flatMapLatest { currency in
                return self.fetchLiveExRateUseCase
                    .execute(with: currency.code)
                    .trackActivity(indicator)
                    .trackError(error)
                    .asDriverOnErrorJustComplete()
        }
        
        let exResult = Driver
            .combineLatest(exRate,
                           input.inputAmount
                            .startWith("0.0")
                            .asDriver()
        )
            .flatMapLatest { (rate, amountString) -> Driver<[ExchangeCurrencyModel] > in
                let inputAmount = ((amountString ?? "0.0") as NSString).floatValue
                let res = rate.quotes.map { (quote) -> ExchangeCurrencyModel in
                    let exAmount = quote.exchangeRate * inputAmount
                    return ExchangeCurrencyModel(rate: quote.exchangeRate,
                                                 code: quote.exchangeCode,
                                                 amount: exAmount)
                }
                return Driver.just(res)
        }.asDriver(onErrorJustReturn: [])
        
        return Output(indicator: indicator.asDriver(),
                      fetchLiveExRateSuccess: exResult,
                      error: error.asDriver())
    }
}
