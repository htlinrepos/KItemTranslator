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
    
    init(data: Data) {
        self.data = data
    }
    
    var header: KItemFormatHeader? {
        data.withUnsafeBytes({ ptr -> KItemFormatHeader? in
            // 确保 Data 的大小足够
            guard ptr.count >= MemoryLayout<KItemFormatHeader>.size else { return nil }
            
            // 将字节数据转换为结构体
            return ptr.load(as: KItemFormatHeader.self)
        })
    }
    
    func getSetItem(id dwSetID: UInt32, from data: Data) -> KItemFormatSetItemData? {
        // 检查无效的输入条件
        guard dwSetID != 0, data.count >= MemoryLayout<KItemFormatHeader>.size else {
            return nil
        }

        // 取出数据起始指针
        let pData = data.withUnsafeBytes { $0.baseAddress }
        guard let pData = pData else { return nil }

        // 解析 Header
        let pkHeader = pData.bindMemory(to: KItemFormatHeader.self, capacity: 1).pointee
        let dwNumSetIDs = pkHeader.m_dwNumSetIDs

        // 计算初始偏移量
        let dwOffset = MemoryLayout<KItemFormatHeader>.size +
            Int(pkHeader.m_dwNumItems) * (MemoryLayout<UInt32>.size + MemoryLayout<KItemFormatTemplet>.size)

        // 获取 SetID 数组的指针
        let pdwSetIDPointer = pData.advanced(by: dwOffset).bindMemory(to: UInt32.self, capacity: Int(dwNumSetIDs))
        let pdwSetIDs = UnsafeBufferPointer(start: pdwSetIDPointer, count: Int(dwNumSetIDs))

        // 在数组中查找目标 SetID
        guard let index = pdwSetIDs.firstIndex(of: dwSetID) else {
            assertionFailure("SetID not found")
            return nil
        }

        // 计算最终偏移量
        let finalOffset = dwOffset +
            Int(dwNumSetIDs) * MemoryLayout<UInt32>.size +
            index * MemoryLayout<KItemFormatSetItemData>.size

        // 获取最终结果指针
        let resultPointer = pData.advanced(by: finalOffset).bindMemory(to: KItemFormatSetItemData.self, capacity: 1)
        return resultPointer.pointee
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
