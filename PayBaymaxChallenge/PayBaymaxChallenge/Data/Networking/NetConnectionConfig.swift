//
//  NetConnectionConfig.swift
//  PayBaymaxChallenge
//
//  Created by Tung Vu on 12/20/20.
//  Copyright © 2020 news. All rights reserved.
//

import Foundation

protocol NetConnectionConfig {
    var baseUrl: String {get set}
    var timeout: Double { get set}
}
