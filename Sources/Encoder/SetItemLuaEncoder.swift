//
//  KItemTranslator
//
//  Created by Erwin Lin on 1/4/25.
//

// 自定义 Lua 编码器
class SetItemLuaEncoder: Encoder {
    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey: Any] = [:]
    
    // 存储编码后的 Lua 代码
    private(set) var luaCode: String = ""
    
    // 返回一个容器，用于编码键值对
    func container<Key: CodingKey>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> {
        return KeyedEncodingContainer(SILuaKeyedEncodingContainer<Key>(encoder: self))
    }
    
    // 返回一个容器，用于编码无键值对（例如数组）
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        return SILuaUnKeyedEncodingContainer(encoder: self)
    }
    
    // 返回一个容器，用于编码单个值
    func singleValueContainer() -> SingleValueEncodingContainer {
        fatalError("Single value encoding is not supported by LuaEncoder")
    }
    
    // 添加 Lua 代码
    func appendLuaCode(_ code: String) {
        luaCode += code
    }
}

// 自定义键值编码容器
struct SILuaKeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
    var codingPath: [CodingKey] = []
    private var encoder: SetItemLuaEncoder
    
    init(encoder: SetItemLuaEncoder) {
        self.encoder = encoder
    }
    
    var template: String {
        """
        g_pCX2SetItemManager:AddSetItemData_LUA
        {
        \(codingString)
        }\n\n
        """
    }
    
    var codingString: String = ""
    
    let padding = "    "
    
    // 编码键值对
    mutating func encode<T: Encodable>(_ value: T, forKey key: Key) throws {
        switch value {
        case let value as Int:
            codingString.append("\(padding)\(key.stringValue) = \(value),")
        case let value as String:
            codingString.append("\n\(padding)\(key.stringValue) = \"\(value)\",")
        case let value as [Int: [Int]]:
            precondition(value.count == 1)
            for (needPartsNum, options) in value {
                codingString.append("\n\(padding)\(key.stringValue) = \(needPartsNum),")
                for (index, option) in options.enumerated() {
                    codingString.append("\n\(padding)m_Option\(index + 1) = \(option),")
                }
            }
            encoder.appendLuaCode(template)
        default:
            break
        }
    }
    
    // 其他方法（未实现）
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

struct SILuaUnKeyedEncodingContainer: UnkeyedEncodingContainer {
    
    private let encoder: SetItemLuaEncoder
    
    var codingPath: [CodingKey] = []
    var count: Int = 0
    
    init(encoder: SetItemLuaEncoder) {
        self.encoder = encoder
    }
    
    func encode<T: Encodable>(_ value: T) throws where T : Encodable {
        if let value = value as? SetItemData {
            try value.encode(to: encoder)
        }
    }
    
    mutating func encodeNil() throws {
        fatalError("Nil value is not supported")
    }
    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError("Nested containers are not supported")
    }
    mutating func nestedUnkeyedContainer() -> any UnkeyedEncodingContainer {
        fatalError("Unkeyed containers are not supported")
    }
    mutating func superEncoder() -> any Encoder {
        fatalError("Super encoder is not supported")
    }
}
