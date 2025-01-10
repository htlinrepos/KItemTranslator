//
//  File.swift
//  DecryptElsword
//
//  Created by Erwin Lin on 12/29/24.
//

import Foundation

struct Loader {
    
    let fileManager = FileManager.default
    
    /// The item.kim file path
    let input: String
    
    private(set) var deserializer: Deserializer?

    mutating func load() -> Bool {
        guard
            input.hasSuffix(".kim") || input.hasSuffix(".KIM"),
            let data = content(path: input)
        else {
            print("The kim file is expected.")
            return false
        }
        
        let formatHeaderSize = MemoryLayout<KItemFormatHeader>.size
        let formatTemplateSize = MemoryLayout<KItemFormatTemplet>.size
        
        guard data.count > formatHeaderSize else {
            print("验证文件大小失败")
            return false
        }
        
        self.deserializer = Deserializer(data: data)
        
        assert(itemFormatHeaderSize == formatHeaderSize)
        assert(itemFormatTempletSize == formatTemplateSize)
        
        guard
            deserializer!.header.m_dwMagic == itemFormatMagic,
            deserializer!.header.m_dwVersion == itemFormatVersion
        else {
            print("文件头验证失败")
            return false
        }
        
        print("文件头验证成功")
        return true
    }
    
    func outputSetItemLuaFile(completionHandler: @escaping () -> Void) {
        DispatchQueue.global(qos: .utility).async {
            guard let deserializer else { return }
            let itemSets = deserializer.itemSets().flatMap {
                $0.toSetItemData(with: deserializer)
            }
            let siEncoder = SetItemLuaEncoder()
            let path = fileManager.currentDirectoryPath + "/SetItem.lua"
            do {
                try itemSets.encode(to: siEncoder)
                try siEncoder.code.data(using: .utf8)?
                    .write(to: .init(fileURLWithPath: path))
            } catch {
                printError(error)
            }
            completionHandler()
        }
    }
    
    func outputItemLuaFile(completionHandler: @escaping () -> Void) {
        DispatchQueue.global(qos: .utility).async {
            guard let deserializer else { return }
            let itemTemplates = deserializer.itemTemplates().map {
                $0.toItemTemplate(with: deserializer)
            }
            let iEncoder = ItemLuaEncoder()
            let path = fileManager.currentDirectoryPath + "/Item.lua"
            do {
                try itemTemplates.encode(to: iEncoder)
                try iEncoder.code.data(using: .utf8)?
                    .write(to: .init(fileURLWithPath: path))
            } catch {
                printError(error)
            }
            completionHandler()
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
