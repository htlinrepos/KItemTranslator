//
//  main.swift
//  coding
//
//  Created by Erwin on 2025/1/2.
//

import Foundation

class KeyValueEncoder: Encoder {
    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    private(set) var storage: String = ""
    
    let padding: String
    
    init(padding: String) {
        self.padding = padding
    }
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        return KeyedEncodingContainer(KeyValueKeydEncodingContainer<Key>(encoder: self))
    }
    
    func appendStorage(_ code: String) {
        storage += "\(padding)\(code)"
    }
}

struct KeyValueKeydEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
    var codingPath: [CodingKey] = []
    
    private let encoder: KeyValueEncoder
    
    init(encoder: KeyValueEncoder) {
        self.encoder = encoder
    }
    
    mutating func encode<T: Encodable>(_ value: T, forKey key: Key) throws {
        switch value {
        case let value as Float:
            guard value != 0.0 else { break }
            encoder.appendStorage("\(key.stringValue) = \(value),\n")
        case let value as Int:
            guard value != 0 else { break }
            encoder.appendStorage("\(key.stringValue) = \(value),\n")
        default:
            break
        }
    }
}
