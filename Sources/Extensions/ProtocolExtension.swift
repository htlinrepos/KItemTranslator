//
//  ProtocolExtension.swift
//  KItemTranslator
//
//  Created by Erwin Lin on 1/5/25.
//

extension Encoder {
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError("Not support")
    }
    
    func singleValueContainer() -> any SingleValueEncodingContainer {
        fatalError("Not support")
    }
}

extension KeyedEncodingContainerProtocol {
    // 其他方法（不需要）
    mutating func encodeNil(forKey key: Key) throws {
        fatalError("Nil value is not supported")
    }
    mutating func nestedContainer<NestedKey: CodingKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
        fatalError("Nested containers are not supported")
    }
    mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        fatalError("Unkeyed containers are not supported")
    }
    mutating func superEncoder() -> Encoder {
        fatalError("Super encoder is not supported")
    }
    mutating func superEncoder(forKey key: Key) -> Encoder {
        fatalError("Super encoder is not supported")
    }
}

extension UnkeyedEncodingContainer {
    // 其他方法（不需要）
    mutating func encodeNil() throws {
        fatalError("Nil value is not supported")
    }
    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError("Nested containers are not supported")
    }
    mutating func nestedUnkeyedContainer() -> any UnkeyedEncodingContainer {
        fatalError("Nested containers are not supported")
    }
    mutating func superEncoder() -> any Encoder {
        fatalError("Super encoder is not supported")
    }
}
