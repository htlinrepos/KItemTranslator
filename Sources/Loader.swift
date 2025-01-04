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
        
        let itemManager = ItemManager(data: data)
        
        precondition(itemFormatHeaderSize == formatHeaderSize)
        precondition(itemFormatTempletSize == formatTemplateSize)
        
        
        assert(itemManager.header.m_dwMagic == itemFormatMagic, "文件头格式错误")
        assert(itemManager.header.m_dwVersion == itemFormatVersion, "文件头格式错误")
        
        print("文件头验证成功")
        
//        let setItemDataExample = itemManager.getSetItem(id: 10, from: data)!
//        print(itemManager.getString(offsetBy: setItemDataExample.m_dwOffset_SetName))
//        print(setItemDataExample.getSetItemNeedPartsNumNOptions(from: data))
        
        let itemTemplateExample = itemManager.getItemTemplate(itemID: 1)!
        print(itemManager.getString(offsetBy: itemTemplateExample.m_dwOffset_Name))
        
        
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
