//
//  File.swift
//  DecryptElsword
//
//  Created by Erwin Lin on 12/29/24.
//

import Foundation

struct Loader {
    
    let fileManager = FileManager.default
    
    /// item.kim file path
    let input: String

    func load() {
        guard
            input.hasSuffix(".kim") || input.hasSuffix(".KIM"),
            let data = content(path: input)
        else {
            print("The kim file is expected.")
            return
        }
        
        let formatHeaderSize = MemoryLayout<KItemFormatHeader>.size
        let formatTemplateSize = MemoryLayout<KItemFormatTemplet>.size
        
        assert(data.count > formatHeaderSize, "验证文件大小失败")
        
        let deserializer = Deserializer(data: data)
        
        precondition(itemFormatHeaderSize == formatHeaderSize)
        precondition(itemFormatTempletSize == formatTemplateSize)
        
        
        assert(deserializer.header.m_dwMagic == itemFormatMagic, "文件头格式错误")
        assert(deserializer.header.m_dwVersion == itemFormatVersion, "文件头格式错误")
        
        print("文件头验证成功")
        
        let itemSets = deserializer.itemSets()
        let preItemSets = itemSets[0..<5].flatMap {
            $0.toSetItemData(with: deserializer)
        }
        print(preItemSets)
        
//        let itemTemplates = deserializer.itemTemplates()
//        let itemTemplateExample = itemTemplates.first!
//        print(deserializer.getString(offsetBy: itemTemplateExample.m_dwOffset_Name))
    }
    
    func content(path: String) -> Data? {
        if let content = fileManager.contents(atPath: path) {
            return content
        } else {
            print("Cannot get the content. Pleas, check the file path.")
            return nil
        }
    }
    
}
