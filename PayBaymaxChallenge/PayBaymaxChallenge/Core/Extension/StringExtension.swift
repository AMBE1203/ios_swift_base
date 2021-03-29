//
//  StringExtension.swift
//  PayBaymaxChallenge
//
//  Created by Tung Vu on 12/20/20.
//  Copyright © 2020 news. All rights reserved.
//

import Foundation

import Foundation

extension String {
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    var currencyFormatted: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ","
        formatter.currencyDecimalSeparator = ","
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        let amount = (self as NSString).doubleValue as NSNumber
        return (formatter.string(from: amount) ?? "")
        
    }
}
