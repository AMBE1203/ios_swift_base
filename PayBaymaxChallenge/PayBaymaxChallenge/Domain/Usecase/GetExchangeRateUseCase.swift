//
//  GetExchangeRateUseCase.swift
//  PayBaymaxChallenge
//
//  Created by Tung Vu on 12/23/20.
//  Copyright © 2020 news. All rights reserved.
//

import Foundation
import RxSwift

protocol GetExchangeRateUseCase {
    func execute(with sourceCurrency: String) -> Observable<ExRateResponseModel>
}

struct GetExchangeRateUseCaseImpl: GetExchangeRateUseCase {
    
    private var repository: CurrencyRepository
    
    init(repository: CurrencyRepository) {
        self.repository = repository
    }
    
    func execute(with sourceCurrency: String) -> Observable<ExRateResponseModel> {
        return repository.fetchLiveExchageRate(with: sourceCurrency)
    }
}
