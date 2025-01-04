//
//  File.swift
//  KItemTranslator
//
//  Created by Erwin Lin on 1/4/25.
//

import Foundation

@propertyWrapper
struct CustomGetter<T> {
    private var value: T
    
    var getter: () -> T
    
    var wrappedValue: T {
        get {
            getter()
        }
        set {
            value = newValue
        }
    }
    
    init(wrappedValue: T, getter: @escaping () -> T) {
        self.value = wrappedValue
        self.getter = getter
    }
}

