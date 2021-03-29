//
//  NetConnection.swift
//  PayBaymaxChallenge
//
//  Created by Tung Vu on 12/20/20.
//  Copyright © 2020 news. All rights reserved.
//

import Foundation
import Alamofire

enum NetWorkReuslt {
    case success(Data)
    case failure(Exception)
}

struct NetConnection {
    
    private var networkStatus: NetworkStatus?
    
    init(networkStatus status: NetworkStatus?) {
        self.networkStatus = status
    }
    
    func request(endpoint point: EndPoint, completion: ((NetWorkReuslt)->Void)?) {
        let isConnected = networkStatus?.isConnected() ?? true
        if !isConnected {
            completion?(.failure(ApiException(message: ExceptionConstants.networkError.message,
                                              code: ExceptionConstants.networkError.code,
                                              httpCode: 0,
                                              status: false)))
        }
        AF.request(point)
            .validate(statusCode: 200..<300)
            .response { (response) in
                self.hanldeResponse(response, completion: completion)
        }
    }
    
    private func hanldeResponse(_ response: AFDataResponse<Data?>, completion: ((NetWorkReuslt)->Void)?) {
        let httpStatusCode = response.response?.statusCode ?? 0
        switch response.result {
        case .success(let data):
            guard let `data` = data else {
                completion?(.failure(ApiException(message: ExceptionConstants.emptyResponseError.message,
                                                  code: ExceptionConstants.emptyResponseError.code,
                                                  httpCode: 0,
                                                  status: false)))
                return
            }
            if (httpStatusCode == 200 || httpStatusCode == 201) {
                completion?(.success(data))
            } else {
                // server response error
                if var serverException = try? ApiException.decode(data: data) {
                    serverException.httpStatusCode = httpStatusCode
                    completion?(.failure(serverException))
                } else {
                    completion?(.failure(ApiException(message: ExceptionConstants.unknown.message,
                                                      code: ExceptionConstants.unknown.code,
                                                      httpCode: 0,
                                                      status: false)))
                }
            }
            break
        case .failure(let error):
            if let data = response.data, var serverException = try? ApiException.decode(data: data) {
                serverException.httpStatusCode = httpStatusCode
                completion?(.failure(serverException))

            } else {

                completion?(.failure(ApiException(message: error.localizedDescription,
                                                  code: ExceptionConstants.unknown.code,
                                                  httpCode: httpStatusCode,
                                                  status:  false)))
            }
        }
    }
}
