//
//  CurrencyRepositoryImpl.swift
//  PayBaymaxChallenge
//
//  Created by Tung Vu on 12/20/20.
//  Copyright © 2020 news. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct CurrencyRepositoryImpl: CurrencyRepository {
    
    private var provider:   CurrencyProvider
    private var api:        ExchangeApi
    
    init(provider: CurrencyProvider, api: ExchangeApi) {
        self.provider = provider
        self.api = api
    }
    
    func fetchAllCurrency() -> Observable<[CurrencyModel]> {
        let observable = Observable<[CurrencyModel]>
            .create { (observer) -> Disposable in
                let currencies = self.provider.getAllCurrency()
                if(currencies.count > 0) {
                    observer.onNext(currencies)
                    observer.onCompleted()
                } else {
                    self.api.fetchSupportedCurrencies {(result) in
                        switch result {
                        case .success(let  value):
                            self.provider.cacheCurrencies(value.currencies)
                            observer.onNext(value.currencies)
                            observer.onCompleted()
                        case .failure(let exception):
                            observer.onError(exception)
                        }
                    }
                }
                
                return Disposables.create()
        }
        return observable
    }
    
    func fetchLiveExchageRate(with sourceCurrency: String) -> Observable<ExRateResponseModel> {
        let observable = Observable<ExRateResponseModel>
            .create { (observer) -> Disposable in
                self.api.fetchLiveExchageRate(with: sourceCurrency) { (result) in
                    switch result {
                    case .success(let  value):
                        observer.onNext(value)
                        observer.onCompleted()
                    case .failure(let exception):
                        observer.onError(exception)
                    }
                }
                return Disposables.create()
        }
        return observable
    }
}
