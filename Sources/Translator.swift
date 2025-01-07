//
//  File.swift
//  
//
//  Created by F7693966 on 10/9/23.
//

import ArgumentParser
import Foundation

@main
struct Translator: ParsableCommand {
    
    @Option(name: [.short, .long], help: "Input kim file path.")
    var input: String
    
    func run() {
        var loader = Loader(input: input)
        
        loader.load()
        
        // 输出
        loader.outputItemLuaFile()
    }
}

