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
    
    private(set) var deserializer: Deserializer?

    mutating func load() {
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
        
        self.deserializer = Deserializer(data: data)
        
        precondition(itemFormatHeaderSize == formatHeaderSize)
        precondition(itemFormatTempletSize == formatTemplateSize)
        
        assert(deserializer!.header.m_dwMagic == itemFormatMagic, "文件头格式错误")
        assert(deserializer!.header.m_dwVersion == itemFormatVersion, "文件头格式错误")
        
        print("文件头验证成功")
    }
    
    func outputSetItemLuaFile() {
        guard let deserializer else { return }
        let itemSets = deserializer.itemSets().flatMap {
            $0.toSetItemData(with: deserializer)
        }
        let siEncoder = SetItemLuaEncoder()
        do {
            try itemSets.encode(to: siEncoder)
            try siEncoder.code.data(using: .utf8)?
                .write(to: fileManager.homeDirectoryForCurrentUser.appendingPathComponent("/Downloads/SetItem.lua"))
        } catch {
            printError(error)
        }
    }
    
    func outputItemLuaFile() {
        guard let deserializer else { return }
        let itemTemplates = deserializer.itemTemplates().map {
            $0.toItemTemplate(with: deserializer)
        }
        let iEncoder = ItemLuaEncoder()
        do {
            try itemTemplates.encode(to: iEncoder)
            try iEncoder.code.data(using: .utf8)?
                .write(to: fileManager.homeDirectoryForCurrentUser.appendingPathComponent("/Downloads/Item.lua"))
        } catch {
            printError(error)
        }
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

func printError<T>(_ value: T) {
    print("!!!!!!!!!!!! Error !!!!!!!!!!!!!!!")
    print("\(value)")
}
