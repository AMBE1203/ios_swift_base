//
//  ExCurrencyModel.swift
//  PayBaymaxChallenge
//
//  Created by Tung Vu on 12/23/20.
//  Copyright © 2020 news. All rights reserved.
//

import Foundation


struct ExchangeCurrencyModel {
    var exRate: Float
    var exCode: String
    var exAmount: Float
    
    init(rate: Float, code: String, amount: Float) {
        self.exRate = rate
        self.exCode = code
        self.exAmount = amount
    }
    
    init() {
        exRate = 0.0
        exCode = ""
        exAmount = 0.0
    }
}
