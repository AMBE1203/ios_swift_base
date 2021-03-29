//
//  ExchangeRateResponse.swift
//  PayBaymaxChallenge
//
//  Created by Tung Vu on 12/21/20.
//  Copyright © 2020 news. All rights reserved.
//

import Foundation

struct ExRateResponseModel {
    var success:    Bool
    var terms:      String
    var privacy:    String
    var timestamp:  Double
    var source:     String
    //    var quotes:     [String: Any]
    var quotes: [QuoteModel]
    
    init() {
        success     = false
        terms       = ""
        privacy     = ""
        timestamp   = 0.0
        source      = ""
        quotes      = []
    }
    
    fileprivate enum ExRateResponseModelKeys: String, CodingKey {
        case success    = "success"
        case terms      = "terms"
        case privacy    = "privacy"
        case timestamp  = "timestamp"
        case source     = "source"
        case quotes     = "quotes"
    }
}

extension ExRateResponseModel: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ExRateResponseModelKeys.self)
        success =  try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        terms = try container.decodeIfPresent(String.self, forKey: .terms) ?? ""
        privacy = try container.decodeIfPresent(String.self, forKey: .privacy) ?? ""
        timestamp = try container.decodeIfPresent(Double.self, forKey: .timestamp) ?? 0.0
        source = try container.decodeIfPresent(String.self, forKey: .source) ?? ""
        let subContainer = try container.nestedContainer(keyedBy: GenericCodingKeys.self, forKey: .quotes)
        quotes = []
        for key in subContainer.allKeys {
            let quote = QuoteModel(code: key.stringValue, rate: (try subContainer.decodeIfPresent(Float.self, forKey: key)) ?? 1.0)
            quotes.append(quote)
        }
        
    }
}

struct QuoteModel {
    var exchangeCode: String
    var exchangeRate: Float
    
    init(code exchangeCode: String,rate exchangeRate: Float) {
        self.exchangeCode = exchangeCode
        self.exchangeRate = exchangeRate
    }
}
