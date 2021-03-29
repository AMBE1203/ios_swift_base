//
//  CurrencyProvider.swift
//  PayBaymaxChallenge
//
//  Created by Tung Vu on 12/20/20.
//  Copyright © 2020 news. All rights reserved.
//

import Foundation

protocol CurrencyProvider {
    func getAllCurrency() -> [CurrencyModel]
    func cacheCurrencies(_ currencies: [CurrencyModel])
}

class CurrencyProviderImpl: CurrencyProvider {
    
    private let CURRENCY_FILE_NAME = "currency"
    private var cachedCurrencies: [CurrencyModel] = []
    static let shared = CurrencyProviderImpl()
    
    private init(){}
    
    func getAllCurrency() -> [CurrencyModel] {
        return cachedCurrencies
        
//        if let path = Bundle.main.path(forResource: CURRENCY_FILE_NAME, ofType: "json") {
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//                if let jsonResult = jsonResult as? Dictionary<String, Any>,
//                    let currencies = jsonResult["currency"] as? [Dictionary<String, Any>] {
//                    let res = currencies.map { (json) -> CurrencyModel in
//                        return CurrencyModel(with: json)
//                    }
//                    return res
//                }
//            } catch {
//                return []
//            }
//        }
//        return [];
    }
    
    func cacheCurrencies(_ currencies: [CurrencyModel]) {
        cachedCurrencies = currencies
    }
}
