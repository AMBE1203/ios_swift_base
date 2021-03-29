//
//  CodableExtension.swift
//  PayBaymaxChallenge
//
//  Created by Tung Vu on 12/20/20.
//  Copyright © 2020 news. All rights reserved.
//

import Foundation

import Foundation

extension Decodable {
    public static func decode(data: Data) throws -> Self {
        let decoder = JSONDecoder()
        return try decoder.decode(Self.self, from: data)
    }
}

// Mark: -- Encodable Extension
extension Encodable {
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(self)
    }
    
    func asDictionary() -> [String: Any]? {
        guard  let data = try? self.encode(), let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return nil
        }
        return dict
    }
    
    func asJsonString() -> String? {
        if let data = try? self.encode() {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}


struct GenericCodingKeys: CodingKey {
    var intValue: Int?
    var stringValue: String
    
    init?(intValue: Int) { self.intValue = intValue; self.stringValue = "\(intValue)" }
    init?(stringValue: String) { self.stringValue = stringValue }
    
    static func makeKey(name: String) -> GenericCodingKeys {
        return GenericCodingKeys(stringValue: name)!
    }
}
