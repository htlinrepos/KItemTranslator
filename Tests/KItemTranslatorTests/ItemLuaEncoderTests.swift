//
//  File.swift
//  KItemTranslator
//
//  Created by Erwin Lin on 1/5/25.
//

import XCTest

@testable
import KItemTranslator

class ItemLuaEncoderTests: XCTestCase {
    let itemTemplates: [ItemTemplet] = [
        .init(m_ItemID: 30154, m_Name: "Banthus\' Bayonet", m_Description: "More useful than I thought?\n- Elsword", m_DescriptionInShop: "", m_ModelName: ["Mesh_Elsword_Elite_Weapon_30008_Sorted.X", "0"], m_TextureChangeXETName: "0", m_AniXETName: "0", m_AniName: "0", m_ShopImage: "HQ_Shop_Elsword_Elite_Weapon_30008.dds", m_DropViewer: "DropItemDrop_Weapon_Elsword", m_ItemType: KItemTranslator.ITEM_TYPE.IT_WEAPON, m_ItemGrade: KItemTranslator.ITEM_GRADE.IG_ELITE, m_bFashion: false, m_bVested: true, m_bCanEnchant: true, m_bCanUseInventory: false, m_bNoEquip: false, m_bIsPcBang: false, m_iItemLevel: 28, m_ucMaxSealCount: 5, m_iMaxAttribEnchantCount: 2, m_UseType: USE_TYPE.UT_ATTACH_ANIM, m_AttachFrameName: ["Dummy1_Rhand", "0"], m_bCanHyperMode: false, m_PeriodType: KItemTranslator.PERIOD_TYPE.PT_ENDURANCE, m_Endurance: 10000, m_EnduranceDamageMin: 50, m_EnduranceDamageMax: 70, m_RepairED: 5.9, m_RepairVP: 0, m_Quantity: 0, m_PriceType: KItemTranslator.SHOP_PRICE_TYPE.SPT_GP, m_Price: 84000, m_PricePvPPoint: 0, m_UseCondition: USE_CONDITION.UC_ONE_UNIT, m_UnitType: UNIT_TYPE.UT_ELSWORD, m_UnitClass: UNIT_CLASS.UC_ELSWORD_SWORDMAN, m_UseLevel: 12, m_BuyPvpRankCondition: PVP_RANK.PVPRANK_NONE, m_EqipPosition: KItemTranslator.EQIP_POSITION.EP_WEAPON_HAND, m_Stat: Stat(m_fBaseHP: 0.0, m_fAtkPhysic: 0.0, m_fAtkMagic: 0.0, m_fDefPhysic: 0.0, m_fDefMagic: 0.0), m_SpecialAbilityList: [SpecialAbility(m_Type: .SAT_ARA_FORCE_POWER_PERCENT_UP, m_CoolTime: 10, m_Value1: 20, m_Value2: 30, m_Value3: 40), SpecialAbility(m_Type: .SAT_ARA_FORCE_POWER_PERCENT_UP, m_CoolTime: 10, m_Value1: 20, m_Value2: 0, m_Value3: 0),], m_vecSocketOption: [1603], m_vecRandomSocketGroupID: [1010], m_kStatRelationLevel: SStatRelationLevel(m_byBaseHPRelLV: 75, m_byAtkPhysicRelLV: 73, m_byAtkMagicRelLV: 77, m_byDefPhysicRelLV: 32, m_byDefMagicRelLV: 1), m_CoolTime: 0, m_SetID: 0, m_iAttributeLevel: 0, m_iBuffFactorID: 0)
    ]
    
    let stat = Stat(m_fBaseHP: 1.0, m_fAtkPhysic: 0, m_fAtkMagic: 2.0, m_fDefPhysic: 10.0, m_fDefMagic: 20.0)
    
    let saList = [
        SpecialAbility(m_Type: .SAT_ARA_FORCE_POWER_PERCENT_UP, m_CoolTime: 10, m_Value1: 20, m_Value2: 30, m_Value3: 40),
        SpecialAbility(m_Type: .SAT_ARA_FORCE_POWER_PERCENT_UP, m_CoolTime: 10, m_Value1: 20, m_Value2: 0, m_Value3: 0),
    ]
    
    let padding = "    "
    let iLuaEncoder = ItemLuaEncoder()
    let keyValueEncoder = KeyValueEncoder(padding: "    ")
    
    func testItemLuaEncode() {
        try? itemTemplates.encode(to: iLuaEncoder)
        print(iLuaEncoder.code)
    }
    
    func testStatLuaEncode() {
        try? stat.encode(to: keyValueEncoder)
        print(keyValueEncoder.code)
    }
    
    func testSpecialAbilityEncode() {
        let kvEncoder = KeyValueEncoder(padding: padding + padding)
        try? saList.encode(to: kvEncoder)
        let string = """
        \(padding){
        \(kvEncoder.code)
        \(padding)}
        """
        print(string)
    }
}
