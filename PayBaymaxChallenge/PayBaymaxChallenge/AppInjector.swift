//
//  AppInjector.swift
//  PayBaymaxChallenge
//
//  Created by Tung Vu on 12/20/20.
//  Copyright © 2020 news. All rights reserved.
//

import Foundation
import Swinject

let injector: Container = {
    let container = Container()
    container.register(NetworkStatus.self) { _ in NetworkStatusImpl.shared}
    
    //API
    container.register(ExchangeApi.self) { (r) -> ExchangeApi in
        ExchangeApiImpl(config: DefaultApiConfig(), networkStatus: r.resolve(NetworkStatus.self)!)
    }
    
    //Repository
    container.register(CurrencyRepository.self) { r in
        CurrencyRepositoryImpl(provider: r.resolve(CurrencyProvider.self)!, api: r.resolve(ExchangeApi.self)!)
    }
    
    //Provider
    container.register(CurrencyProvider.self) { _ in CurrencyProviderImpl.shared}
    
    //Usecases
    container.register(GetAllCurrencyUseCase.self) { (r) in GetAllCurrencyUseCaseImpl(repository: r.resolve(CurrencyRepository.self)!) }
    container.register(GetExchangeRateUseCase.self) { (r) in
        GetExchangeRateUseCaseImpl(repository: r.resolve(CurrencyRepository.self)!)
    }
    
    //ViewModel
    container.register(CurrenciesViewModel.self) { (r) in
        CurrenciesViewModel(usecase: r.resolve(GetAllCurrencyUseCase.self)!)
    }
    container.register(ExRateViewModel.self) { (r) in
        ExRateViewModel(usecase: r.resolve(GetExchangeRateUseCase.self)!)
    }
    
    return container
}()

