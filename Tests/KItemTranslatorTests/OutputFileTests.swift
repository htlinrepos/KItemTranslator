//
//  OutputFileTests.swift
//  KItemTranslator
//
//  Created by Erwin Lin on 1/5/25.
//

import XCTest

class OutputFileTests: XCTestCase {
    
    let fileManager = FileManager.default
    let string = "数据测试: \(Int.random(in: 0..<10))"
    
    func testDataWrite() throws {
        let url = fileManager.homeDirectoryForCurrentUser.appendingPathComponent("Downloads/KItemTranslator.txt")
        print(url)
        
        let parentDirectory = url.deletingLastPathComponent()
        if !FileManager.default.fileExists(atPath: parentDirectory.path) {
            do {
                try FileManager.default.createDirectory(at: parentDirectory, withIntermediateDirectories: true, attributes: nil)
                print("父目录创建成功")
            } catch {
                print("创建父目录失败：\(error.localizedDescription)")
                return
            }
        }
        
        try string.data(using: .utf16LittleEndian)?.write(to: url)
    }
}
