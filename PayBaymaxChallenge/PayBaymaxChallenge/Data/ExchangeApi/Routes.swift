//
//  Routes.swift
//  PayBaymaxChallenge
//
//  Created by Tung Vu on 12/20/20.
//  Copyright © 2020 news. All rights reserved.
//

import Foundation
import Alamofire

enum ExchangeApiRoutes: Route {
    
    case liveExchangeRate(sourceCurrency: String, apiKey: String)
    case supportedCurrencies(apiKey: String)
    
    var method: HTTPMethod {
        switch self {
        case .liveExchangeRate(_,_), .supportedCurrencies(_):
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .liveExchangeRate(_,_):
            return "live"
        case .supportedCurrencies(_):
            return "list"
        }
    }
    
    var parametters: Parameters? {
        switch self {
        case .liveExchangeRate(let sourceCurrency, let apiKey):
            return ["access_key":apiKey,
                    "source": sourceCurrency]
        case .supportedCurrencies(let apiKey):
            return ["access_key":apiKey]
        }
    }
}
