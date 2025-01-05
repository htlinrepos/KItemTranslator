//
//  ItemSetsEncoderTests.swift
//  KItemTranslator
//
//  Created by Erwin Lin on 1/4/25.
//

import XCTest

@testable
import KItemTranslator

class SetItemLuaEncoderTests: XCTestCase {
    // 示例数据
    let itemSets: [SetItemData] = [
        SetItemData(m_SetID: 10, m_SetName: "Red Giant Set", m_mapNeedPartsNumNOptions: [2: [30005]]),
        SetItemData(m_SetID: 10, m_SetName: "Red Giant Set", m_mapNeedPartsNumNOptions: [4: [30005, 30015]]),
        SetItemData(m_SetID: 10, m_SetName: "Red Giant Set", m_mapNeedPartsNumNOptions: [5: [30005, 30015, 30020]])
    ]

    let siEncoder = SetItemLuaEncoder()
    
    func testEncode() {
        try? itemSets.encode(to: siEncoder)
        XCTAssertFalse(siEncoder.luaCode.isEmpty)
        print(siEncoder.luaCode)
    }
}
