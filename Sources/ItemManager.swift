//
//  File.swift
//  KItemDeserializer
//
//  Created by Erwin Lin on 1/1/25.
//

import Foundation

let dwordSize = 4
let itemFormatHeaderSize = 16
let itemFormatTempletSize = 188
let itemFormatSetItemDataSize = 20
let itemForamtNeedPartsNumAndOption = 8

let itemFormatMagic = ItemManager.MAKEFOURCC()
let itemFormatVersion = 0x1201

/// 持有并管理`data`，读取`SetItemData`和`ItemTemplate`数据，以及共享处理 `data` 的方法
class ItemManager {
    let data: Data
    let header: KItemFormatHeader
    
    init(data: Data) {
        self.data = data
        header = data.withUnsafeBytes({ ptr -> KItemFormatHeader in
            // 确保 Data 的大小足够
            guard ptr.count >= MemoryLayout<KItemFormatHeader>.size else {
                fatalError("Not enough data size.")
            }
            
            // 将字节数据转换为结构体
            return ptr.load(as: KItemFormatHeader.self)
        })
    }
    
    func itemTemplates() -> [KItemFormatTemplet] {
        // 获取物品数量
        let dwNumItems = Int(header.m_dwNumItems)
        
        guard dwNumItems != 0 else { return [] }
        // 获取数据指针
        let pData = data.withUnsafeBytes { $0.baseAddress }
        
        guard let pData else { return [] }
        // 计算物品模板数组的起始指针
        let pTemplates = pData.advanced(by: itemFormatHeaderSize + dwordSize * dwNumItems)
                              .assumingMemoryBound(to: KItemFormatTemplet.self)
        
        // 创建结果数组
        var templates = [KItemFormatTemplet]()
        
        // 遍历所有物品模板
        for i in 0..<dwNumItems {
            let template = pTemplates.advanced(by: i).pointee
            templates.append(template)
        }
        
        return templates
    }
    
    func itemSets() -> [KItemFormatSetItemData] {
        // 检查数据是否足够解析 Header
        guard data.count >= itemFormatHeaderSize else {
            return []
        }
        // 取出数据起始指针
        let pData = data.withUnsafeBytes { $0.baseAddress }
        
        guard let pData = pData else { return [] }
        // 解析 Header
        let pkHeader = pData.bindMemory(to: KItemFormatHeader.self, capacity: 1).pointee
        let dwNumSetIDs = pkHeader.m_dwNumSetIDs

        // 计算初始偏移量
        let dwOffset = itemFormatHeaderSize + Int(pkHeader.m_dwNumItems) * (dwordSize + itemFormatTempletSize)

        // 计算套装数据的起始指针
        let pSetItems = pData
            .advanced(by: dwOffset + Int(dwNumSetIDs) * dwordSize)
            .bindMemory(to: KItemFormatSetItemData.self, capacity: Int(dwNumSetIDs))

        // 创建结果数组
        var setItems = [KItemFormatSetItemData]()

        // 遍历所有套装数据
        for i in 0..<Int(dwNumSetIDs) {
            let setItem = pSetItems.advanced(by: i).pointee
            setItems.append(setItem)
        }

        return setItems
    }
}

extension ItemManager {
    func getString(offsetBy dwOffset: UInt32) -> String {
        guard dwOffset != 0 else { return "" }
        // 读取长度（WORD 是 2 字节）
        let wLength = data.withUnsafeBytes { buffer in
            buffer.load(fromByteOffset: Int(dwOffset), as: UInt16.self)
        }
        
        guard wLength != 0 else { return "" }

        let startIndex = Int(dwOffset) + MemoryLayout<UInt16>.size
        let stringData = data[startIndex ..< startIndex + Int(wLength) * 2]
        
        guard
            let string = String(data: stringData, encoding: .utf16LittleEndian)
        else { fatalError("Encoding failed.") }
        
        return string
    }
}

extension ItemManager {
    static func MAKEFOURCC(_ ch0: Character = "K", _ ch1: Character = "I", _ ch2: Character = "M", _ ch3: Character = " ") -> UInt32 {
        let byte0 = UInt32(ch0.asciiValue ?? 0)
        let byte1 = UInt32(ch1.asciiValue ?? 0)
        let byte2 = UInt32(ch2.asciiValue ?? 0)
        let byte3 = UInt32(ch3.asciiValue ?? 0)

        return byte0 | (byte1 << 8) | (byte2 << 16) | (byte3 << 24)
    }
}
