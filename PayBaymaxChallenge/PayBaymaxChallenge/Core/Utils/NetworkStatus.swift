//
//  NetworkStatus.swift
//  PayBaymaxChallenge
//
//  Created by Tung Vu on 12/20/20.
//  Copyright © 2020 news. All rights reserved.
//

import Foundation
import Reachability

protocol NetworkStatus {
    func isConnected() -> Bool
}

class NetworkStatusImpl: NetworkStatus {
    
    static let shared = NetworkStatusImpl()
    
    func isConnected() -> Bool {
        return connected
    }
    
    private let reachability = try! Reachability()
    private var connected: Bool = true
    
    private init() {
        reachability.whenReachable = { _ in
            self.connected = true
        }
        reachability.whenUnreachable = { _ in
            self.connected = false
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}



