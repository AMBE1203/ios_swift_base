//
//  GetAllCurrencyUseCase.swift
//  PayBaymaxChallenge
//
//  Created by Tung Vu on 12/20/20.
//  Copyright © 2020 news. All rights reserved.
//

import Foundation
import RxSwift

protocol GetAllCurrencyUseCase {
    func execute() -> Observable<[CurrencyModel]>
}

struct GetAllCurrencyUseCaseImpl: GetAllCurrencyUseCase {
    
    private var repository: CurrencyRepository
    
    init(repository: CurrencyRepository) {
        self.repository = repository
    }
    
    func execute() -> Observable<[CurrencyModel]> {
        return repository.fetchAllCurrency();
    }
}
