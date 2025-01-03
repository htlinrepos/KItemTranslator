//
//  File.swift
//  
//
//  Created by F7693966 on 10/9/23.
//

import ArgumentParser
import Foundation

@main
struct Deserializer: ParsableCommand {
    
    @Option(name: [.short, .long], help: "Input kim file path.")
    var input: String
    
    func run() {
        let loader = Loader(input: input)
        loader.load()
    }
}

