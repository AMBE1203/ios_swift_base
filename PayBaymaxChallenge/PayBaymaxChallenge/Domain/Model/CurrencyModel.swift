//
//  CurrencyModel.swift
//  PayBaymaxChallenge
//
//  Created by Tung Vu on 12/20/20.
//  Copyright © 2020 news. All rights reserved.
//

import Foundation


struct SupportedCurrenciesModel {
    var success:    Bool
    var terms:      String
    var privacy:    String
    var currencies: [CurrencyModel]
    
    init() {
        success     = false
        terms       = ""
        privacy     = ""
        currencies  = []
    }
    
    fileprivate enum SupportedCurrenciesModelKeys: String, CodingKey {
        case success        = "success"
        case terms          = "terms"
        case privacy        = "privacy"
        case currencies     = "currencies"
    }
}

extension SupportedCurrenciesModel: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SupportedCurrenciesModelKeys.self)
        success =  try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        terms = try container.decodeIfPresent(String.self, forKey: .terms) ?? ""
        privacy = try container.decodeIfPresent(String.self, forKey: .privacy) ?? ""
        let subContainer = try container.nestedContainer(keyedBy: GenericCodingKeys.self, forKey: .currencies)
        currencies = []
        for key in subContainer.allKeys {
            var currency = CurrencyModel()
            currency.code = key.stringValue
            currency.name = (try subContainer.decodeIfPresent(String.self, forKey: key)) ?? ""
            currencies.append(currency)
        }
        
    }
}



struct CurrencyModel {
    var code: String
    var name: String
    
    init() {
        self.code = "USD"
        self.name = "US Dollar"
    }
    
    init(with json:Dictionary<String, Any>) {
        self.code = (json[CurrencyModelKeys.codeKey.stringValue] as? String) ?? ""
        self.name = (json[CurrencyModelKeys.nameKey.stringValue] as? String) ?? ""
    }
    
    fileprivate enum CurrencyModelKeys: String, CodingKey {
        case codeKey = "code"
        case nameKey = "name"
    }
}

extension CurrencyModel: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CurrencyModelKeys.self)
        code =  try container.decodeIfPresent(String.self, forKey: .codeKey) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .nameKey) ?? ""
    }
}
