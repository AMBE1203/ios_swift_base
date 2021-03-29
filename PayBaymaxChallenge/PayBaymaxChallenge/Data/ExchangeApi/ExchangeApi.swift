//
//  ExchangeApi.swift
//  PayBaymaxChallenge
//
//  Created by Tung Vu on 12/21/20.
//  Copyright © 2020 news. All rights reserved.
//

import Foundation

enum APIReuslt<T: Decodable> {
    case success(T)
    case failure(Exception)
}

typealias ApiCompletion<T: Decodable> = (APIReuslt<T>) -> Void

protocol ExchangeApi {
    func fetchSupportedCurrencies(completion:ApiCompletion<SupportedCurrenciesModel>?)
    func fetchLiveExchageRate(with sourceCurrency: String, completion:ApiCompletion<ExRateResponseModel>?)
    
}

struct ExchangeApiImpl: ExchangeApi {
    
    private var networkStatus:  NetworkStatus?
    private var apiConfig:  DefaultApiConfig
    
    init(config: DefaultApiConfig, networkStatus: NetworkStatus?) {
        self.apiConfig = config
        self.networkStatus = networkStatus
    }
    
    func fetchLiveExchageRate(with sourceCurrency: String,
                              completion: ApiCompletion<ExRateResponseModel>?) {
        NetConnection(networkStatus: self.networkStatus)
            .request(endpoint: EndPoint(
                route: ExchangeApiRoutes.liveExchangeRate(
                    sourceCurrency: sourceCurrency,
                    apiKey: apiConfig.apiKey),
                netConfig: apiConfig, header: [:])) { (result) in
                    switch result {
                    case .success(let data):
                        //let json =  try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                        if let res = try? ExRateResponseModel.decode(data: data)  {
                            completion?(.success(res))
                        } else {
                            let error  = (try? ApiException.decode(data: data)) ?? ApiException(
                                message: "Response Error",
                                code: "",
                                httpCode: 200,
                                status: false)
                            completion?(.failure(error))
                        }
                        break
                    case .failure(let error):
                        completion?(.failure(error))
                        break
                    }
        }
    }
    
    func fetchSupportedCurrencies(completion: ApiCompletion<SupportedCurrenciesModel>?) {
        NetConnection(networkStatus: self.networkStatus)
            .request(endpoint: EndPoint(
                route: ExchangeApiRoutes.supportedCurrencies(apiKey: apiConfig.apiKey),
                netConfig: apiConfig, header: [:])) { (result) in
                    switch result {
                    case .success(let data):
                        if let res = try? SupportedCurrenciesModel.decode(data: data)  {
                            completion?(.success(res))
                        } else {
                            let error  = (try? ApiException.decode(data: data)) ?? ApiException(
                                message: "Response Error",
                                code: "",
                                httpCode: 200,
                                status: false)
                            completion?(.failure(error))
                        }
                        break
                    case .failure(let error):
                        completion?(.failure(error))
                        break
                    }
        }
    }
}
