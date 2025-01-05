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
        KeyedEncodingContainer(KeyValueKeyedEncodingContainer<Key>(encoder: self))
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        KeyValueUnKeyedEncoding(encoder: self, padding: padding)
    }
    
    func append(_ code: String) {
        storage += "\(code)"
    }
    
    func appendWithPadding(_ code: String) {
        storage += "\(padding)\(code)"
    }
}

struct KeyValueKeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
    var codingPath: [CodingKey] = []
    
    private let encoder: KeyValueEncoder
    
    init(encoder: KeyValueEncoder) {
        self.encoder = encoder
    }
    
    mutating func encode<T: Encodable>(_ value: T, forKey key: Key) throws {
        switch value {
        case let value as Float:
            guard value != 0.0 else { break }
            encoder.appendWithPadding("\(key.stringValue) = \(value),\n")
        case let value as Int:
            guard value != 0 else { break }
            encoder.appendWithPadding("\(key.stringValue) = \(value),\n")
        case let value as SPECIAL_ABILITY_TYPE:
            guard value != .SAT_NONE else { break }
            encoder.appendWithPadding("\(key.stringValue) = \(value),\n")
        default:
            break
        }
    }
}

struct KeyValueUnKeyedEncoding: UnkeyedEncodingContainer {
    var codingPath: [any CodingKey] = []
    var count: Int = 0
    
    let encoder: KeyValueEncoder
    let padding: String
    
    init(encoder: KeyValueEncoder, padding: String) {
        self.encoder = encoder
        self.padding = padding
    }
    
    func encode<T>(_ value: T) throws where T : Encodable {
        if let value = value as? SpecialAbility {
            guard value != SpecialAbility.default else { return }
            let encoder = KeyValueEncoder(padding: padding + "    ")
            try value.encode(to: encoder)
            let string = """
            \(padding){
            \(encoder.storage.dropLast())
            \(padding)},\n
            """
            self.encoder.append(string)
        }
    }
}
