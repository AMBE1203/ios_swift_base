//
//  ExchangeApi.swift
//  PayBaymaxChallenge
//
//  Created by Tung Vu on 12/20/20.
//  Copyright © 2020 news. All rights reserved.
//

import Foundation

let EXCHANGE_API_BASE_URL   = "http://api.currencylayer.com/"
let DEFAULT_API_TIMEOUT     = 60.0
let API_KEY                 = "0bffcdbddb1880f876cb7346f247d0b1"

struct DefaultApiConfig: NetConnectionConfig {
    var baseUrl: String     = EXCHANGE_API_BASE_URL
    var timeout: Double     = DEFAULT_API_TIMEOUT
    var apiKey: String      = API_KEY
}
