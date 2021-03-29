//
//  CurrencyRepository.swift
//  PayBaymaxChallenge
//
//  Created by Tung Vu on 12/20/20.
//  Copyright © 2020 news. All rights reserved.
//

import Foundation
import RxSwift

protocol CurrencyRepository {
    func fetchAllCurrency() -> Observable<[CurrencyModel]>
    func fetchLiveExchageRate(with sourceCurrency: String) -> Observable<ExRateResponseModel>
}
