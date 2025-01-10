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
    @Argument(help: "The kim file path.")
    var input: String
    
    func run() {
        var loader = Loader(input: input)
        
        guard loader.load() else {
            print("Load failed.")
            Translator.exit()
        }
        
        print("开始解析...")
        
        let group = DispatchGroup()
        
        group.enter()
        loader.outputItemLuaFile {
            group.leave()
        }
        
        group.enter()
        loader.outputSetItemLuaFile {
            group.leave()
        }
        
        group.wait()
        
        print("Done.")
    }
}

