//
//  File.swift
//  KItemTranslator
//
//  Created by Erwin Lin on 1/4/25.
//

import XCTest

@testable
import KItemTranslator

class CustormGetterTests: XCTestCase {
    @CustomGetter(getter: { print("Trigger"); return 1 })
    var value: Int = 10
    
    func testValue() {
        value = 20
        XCTAssertEqual(1, value)
    }
}
