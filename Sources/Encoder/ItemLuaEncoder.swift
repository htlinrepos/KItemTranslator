//
//  Untitled.swift
//  KItemTranslator
//
//  Created by Erwin Lin on 1/5/25.
//

import Foundation

class ItemLuaEncoder: Encoder {
    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    // 存储编码后的 Lua 代码
    private var luaCode: String = ""
    
    var code: String {
        String(luaCode.dropLast(2))
    }
    
    // 添加 Lua 代码
    func appendLuaCode(_ code: String) {
        luaCode += code
    }
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {   
        KeyedEncodingContainer(ILuaKeyedEncodingContainer(encoder: self))
    }
    
    func unkeyedContainer() -> any UnkeyedEncodingContainer {
        ILuaUnKeyedEncodingContainer(encoder: self)
    }
}

struct ILuaKeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
    var codingPath: [CodingKey] = []
    
    private let encoder: ItemLuaEncoder
    
    init(encoder: ItemLuaEncoder) {
        self.encoder = encoder
    }
    
    var template: String {
        """
        g_pItemManager:AddItemTemplet
        {
        \(codingString)
        }\n\n
        """
    }
    
    private var codingString = ""
    
    let padding = "    "
    
    mutating func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
        defer {
            if key.stringValue == "BUFF_FACTOR" {
                codingString.removeLast()
                encoder.appendLuaCode(template)
            }
        }
        
        switch value {
        case let value as Int:
            switch key.stringValue {
            case "m_ItemID", "m_Endurance":
                guard value != -1 else { break }
                codingString.append("\(padding)\(key.stringValue) = \(value),\n")
            default:
                guard value != 0 else { break }
                codingString.append("\(padding)\(key.stringValue) = \(value),\n")
            }
        case let value as Float:
            guard value != 0.0 else { break }
            codingString.append("\(padding)\(key.stringValue) = \(value),\n")
        case let value as String:
            guard !value.isEmpty else { break }
            let data = try JSONEncoder().encode(value)
            guard let string = String(data: data, encoding: .utf8) else {
                printError(value)
                break
            }
            codingString.append("\(padding)\(key.stringValue) = \(string),\n")
        case let value as [String]:
            guard !value.isEmpty else { break }
            for (i, str) in value.enumerated() {
                guard !str.isEmpty else { continue }
                let index = "\(i)"
                codingString.append("\(padding)\(i > 0 ? (key.stringValue + index) : key.stringValue) = \"\(str)\",\n")
            }
        case let value as Bool:
            guard value == true else { break }
            codingString.append("\(padding)\(key.stringValue) = True,\n")
        case let value as ITEM_TYPE:
            guard value != .IT_NONE else { break }
            codingString.append("\(padding)\(key.stringValue) = ITEM_TYPE[\"\(value)\"],\n")
        case let value as ITEM_GRADE:
            guard value != .IG_NONE else { break }
            codingString.append("\(padding)\(key.stringValue) = ITEM_GRADE[\"\(value)\"],\n")
        case let value as USE_TYPE:
            guard value != .UT_NONE else { break }
            codingString.append("\(padding)\(key.stringValue) = USE_TYPE[\"\(value)\"],\n")
        case let value as PERIOD_TYPE:
            guard value != .PT_INFINITY else { break }
            codingString.append("\(padding)\(key.stringValue) = PERIOD_TYPE[\"\(value)\"],\n")
        case let value as SHOP_PRICE_TYPE:
            codingString.append("\(padding)\(key.stringValue) = SHOP_PRICE_TYPE[\"\(value)\"],\n")
        case let value as USE_CONDITION:
            guard value != .UC_NONE else { break }
            codingString.append("\(padding)\(key.stringValue) = USE_CONDITION[\"\(value)\"],\n")
        case let value as UNIT_TYPE:
            guard value != .UT_NONE else { break }
            codingString.append("\(padding)\(key.stringValue) = UNIT_TYPE[\"\(value)\"],\n")
        case let value as UNIT_CLASS:
            guard value != .UC_NONE else { break }
            codingString.append("\(padding)\(key.stringValue) = UNIT_CLASS[\"\(value)\"],\n")
        case let value as PVP_RANK:
            guard value != .PVPRANK_NONE else { break }
            codingString.append("\(padding)\(key.stringValue) = PVP_RANK[\"\(value)\"],\n")
        case let value as EQIP_POSITION:
            guard value != .EP_NONE else { break }
            codingString.append("\(padding)\(key.stringValue) = EQIP_POSITION[\"\(value)\"],\n")
        case let value as Stat:
            guard value != Stat.default else { break }
            let kvEncoder = KeyValueEncoder(padding: padding + padding)
            try value.encode(to: kvEncoder)
            let string = """
            \(padding)\(key.stringValue) =
            \(padding){
            \(kvEncoder.code)
            \(padding)},\n
            """
            codingString.append(string)
        case let value as [SpecialAbility]:
            guard !value.isEmpty else { break }
            let kvEncoder = KeyValueEncoder(padding: padding + padding)
            try value.encode(to: kvEncoder)
            let string = """
            \(padding)\(key.stringValue) =
            \(padding){
            \(kvEncoder.code)
            \(padding)},\n
            """
            codingString.append(string)
        case let value as [Int]:
            guard !value.isEmpty else { break }
            let string = """
            \(padding)\(key.stringValue) = { \(value.description.dropFirst().dropLast()) },\n
            """
            codingString.append(string)
        case let value as SStatRelationLevel:
            guard value != SStatRelationLevel.default else { break }
            let kvEncoder = KeyValueEncoder(padding: padding + padding)
            try value.encode(to: kvEncoder)
            let string = """
            \(padding)\(key.stringValue) =
            \(padding){
            \(kvEncoder.code)
            \(padding)},\n
            """
            codingString.append(string)
        case let value as BUFF_FACTOR_ID:
            guard value != .BFI_NONE else { break }
            let string = """
            \(padding)\(key.stringValue) =
            \(padding){
            \(padding)\(padding)BUFF_FACTOR_ID["\(value)"],
            \(padding)},\n
            """
            codingString.append(string)
        default:
            printError(value)
            break
        }
    }
}

struct ILuaUnKeyedEncodingContainer: UnkeyedEncodingContainer {
    var codingPath: [CodingKey] = []
    var count: Int = 0
    
    private let encoder: ItemLuaEncoder
    
    init(encoder: ItemLuaEncoder) {
        self.encoder = encoder
    }
    
    func encode<T>(_ value: T) throws where T : Encodable {
        if let value = value as? ItemTemplet {
            try value.encode(to: encoder)
        }
    }
}
