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
        
        assert(data.count > MemoryLayout<KItemFormatHeader>.size, "验证文件大小失败")
        
        let itemManager = ItemManager()
        
        guard let header = itemManager.createHeader(from: data) else {
            print("Failed to create header.")
            return
        }
        
        assert(header.m_dwMagic == itemManager.itemFormatMagic, "文件头格式错误")
        assert(header.m_dwVersion == itemManager.itemFormatVersion, "文件头格式错误")
        
        print("文件头验证成功")
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
