//
//  Exception.swift
//  PayBaymaxChallenge
//
//  Created by Tung Vu on 12/20/20.
//  Copyright © 2020 news. All rights reserved.
//

import Foundation

import Foundation

protocol Exception: Error {
    var message: String {get set}
    var code: String {get set}
    var httpStatusCode: Int {get set}
}

extension Error {
    func errorMessage() -> String {
        var msg = self.localizedDescription
        if let ex = self as? Exception {
            msg = ex.message
        }
        return msg
    }
}

struct ApiException: Exception {
    var message: String
    var code: String
    var httpStatusCode: Int
    
    init(message msg: String,
         code value: String,
         httpCode httpStatus: Int,
         status statusValue: Bool?) {
        self.message = msg
        self.code = value
        self.httpStatusCode = httpStatus
    }
    
    enum ApiExceptionKeys: String, CodingKey {
        case error  = "error"
    }
    
    enum ApiErrorInfoKey: String, CodingKey {
        case code   = "code"
        case info   = "info"
    }
}

extension ApiException: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ApiExceptionKeys.self)
        
        let subContainer = try container.nestedContainer(keyedBy: ApiErrorInfoKey.self, forKey: .error)
        message = try subContainer.decodeIfPresent(String.self, forKey: .info) ?? "unknown message"
        code = "\(try subContainer.decodeIfPresent(Int.self, forKey: .code) ?? 0)"
        httpStatusCode = 0
        
    }
}

enum ExceptionConstants {
    case networkError
    case internalError
    case unknown
    case emptyResponseError
    
    var message: String {
        switch self {
        case .networkError:
            return NETWORK_ERROR_MESSAGE
        case .internalError:
            return INTERNAL_MESSAGE
        case .unknown:
            return UNKNOWN_ERROR_MESSAGE
        case .emptyResponseError:
            return EMPTY_RESPONSE_ERROR_MESSAGE
        }
    }
    
    var code: String {
        switch self {
        case .networkError:
            return NETWORK_ERROR_CODE
        case .internalError:
            return INTERNAL_ERROR_CODE
        case .unknown:
            return UNKNOWN_ERROR_CODE
        case .emptyResponseError:
            return EMPTY_RESPONSE_ERROR_CODE
        }
    }
}


fileprivate let NETWORK_ERROR_MESSAGE = "Network error. Please check your connection."
fileprivate let INTERNAL_MESSAGE = "Network error. Please check your connection."
fileprivate let UNKNOWN_ERROR_MESSAGE = "Unknown error"
fileprivate let EMPTY_RESPONSE_ERROR_MESSAGE = "Server response error. No data response"

fileprivate let NETWORK_ERROR_CODE = "NETWORK_ERROR_CODE"
fileprivate let INTERNAL_ERROR_CODE = "INTERNAL_ERROR_CODE"
fileprivate let UNKNOWN_ERROR_CODE = "UNKNOWN_ERROR_CODE"
fileprivate let EMPTY_RESPONSE_ERROR_CODE = "EMPTY_RESPONSE_ERROR_CODE"
