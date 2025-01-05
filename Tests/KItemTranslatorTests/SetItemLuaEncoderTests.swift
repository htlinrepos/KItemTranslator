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
    
    let targetCode = """
    g_pCX2SetItemManager:AddSetItemData_LUA
    {
        m_SetID = 10,
        m_SetName = "Red Giant Set",
        m_NeedPartsNum = 2,
        m_Option1 = 30005,
    }

    g_pCX2SetItemManager:AddSetItemData_LUA
    {
        m_SetID = 10,
        m_SetName = "Red Giant Set",
        m_NeedPartsNum = 4,
        m_Option1 = 30005,
        m_Option2 = 30015,
    }

    g_pCX2SetItemManager:AddSetItemData_LUA
    {
        m_SetID = 10,
        m_SetName = "Red Giant Set",
        m_NeedPartsNum = 5,
        m_Option1 = 30005,
        m_Option2 = 30015,
        m_Option3 = 30020,
    }
    """

    let siEncoder = SetItemLuaEncoder()
    
    func testEncode() {
        try? itemSets.encode(to: siEncoder)
        XCTAssertEqual(siEncoder.code, targetCode)
    }
}
