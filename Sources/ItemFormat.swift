//
//  ItemKim.swift
//  DecryptElsword
//
//  Created by Erwin Lin on 1/1/25.
//

import Foundation

let MAX_MODEL_COUNT_A_ITEM = 6

struct KItemFormatHeader {
    var m_dwMagic: UInt32 = 0
    var m_dwVersion: UInt32 = 0
    var m_dwNumItems: UInt32 = 0
    var m_dwNumSetIDs: UInt32 = 0
}

struct KItemFormatType_OffsetOrValue {
    var m_dwType: UInt32 = 0
    var m_dwOffsetOrValue: UInt32 = 0
}

struct KItemFormatSpecialAbility {
    var m_dwType: UInt32 = 0
    var m_CoolTime: Int32 = 0
    var m_Value1: Int32 = 0
    var m_Value2: Int32 = 0
    var m_Value3: Int32 = 0
    var m_dwOffset_StringValue1: UInt32 = 0
}

struct KItemFormatAttachedData {
    var m_dwOffset_Name: UInt32 = 0
    var m_dwOffset_BoneName: UInt32 = 0
}

struct KItemFormatStatData {
    var m_fBaseHP: Float = 0
    var m_fAtkPhysic: Float = 0
    var m_fAtkMagic: Float = 0
    var m_fDefPhysic: Float = 0
    var m_fDefMagic: Float = 0
}

struct KItemFormatStatRelLVData {
    var m_byBaseHPRelLV: UInt8 = 0
    var m_byAtkPhysicRelLV: UInt8 = 0
    var m_byAtkMagicRelLV: UInt8 = 0
    var m_byDefPhysicRelLV: UInt8 = 0
    var m_byDefMagicRelLV: UInt8 = 0
}

struct KItemForamtNeedPartsNumAndOption {
    var m_dwNeedPartsNum: UInt32 = 0
    var m_iOption: Int32 = 0
}

struct KItemFormatSetItemData {
    var m_dwSetID: UInt32 = 0
    var m_iMaxLevel: Int32 = 0
    var m_dwOffset_SetName: UInt32 = 0
    var m_dwOffset_ItemIDs: UInt32 = 0
    var m_dwOffset_NeedPartsNumNOptions: UInt32 = 0
    
    func getSetItemNeedPartsNumNOptions(from data: Data) -> [KItemForamtNeedPartsNumAndOption] {
        guard m_dwOffset_NeedPartsNumNOptions != 0 else { return [] }
        let offset = Int(m_dwOffset_NeedPartsNumNOptions)
        let dwNum = data.withUnsafeBytes { $0.load(fromByteOffset: offset, as: UInt32.self) }
        
        guard dwNum != 0 else { return [] }
        let pData = data.withUnsafeBytes { $0.baseAddress }
        
        guard let pData = pData else { return [] }
        let furtherOffset = offset + dwordSize
        let needPartsNumAndOptionsPtr = pData
            .advanced(by: furtherOffset)
            .assumingMemoryBound(to: KItemForamtNeedPartsNumAndOption.self)
        let needPartsNumAndOptions = UnsafeBufferPointer(start: needPartsNumAndOptionsPtr, count: Int(dwNum))
        return Array(needPartsNumAndOptions)
    }
}

struct KItemFormatTemplet {
    var m_dwItemID: UInt32 = 0
    var m_dwFlags: UInt32 = 0
    var m_dwFlags2: UInt32 = 0
    var m_iItemLevel: Int32 = 0
    var m_iQuantity: Int32 = 0
    var m_fRepairED: Float = 0
    var m_iRepairVP: Int32 = 0
    var m_iPrice: Int32 = 0
    var m_iPricePvPPoint: Int32 = 0
    var m_iSetID: Int32 = 0
    var m_fAddMaxMP: Float = 0
    
    var m_dwOffset_Name: UInt32 = 0
    var m_dwOffset_Description: UInt32 = 0
    var m_dwOffset_DescriptionInShop: UInt32 = 0
    var m_adwOffset_AttachFrameName: (UInt32, UInt32, UInt32, UInt32, UInt32, UInt32)
    var m_adwOffset_ModelName: (UInt32, UInt32, UInt32, UInt32, UInt32, UInt32)
    var m_dwOffset_TextureChangeXETName: UInt32 = 0
    var m_dwOffset_AniXETName: UInt32 = 0
    var m_dwOffset_AniName: UInt32 = 0
    var m_dwOffset_ShopImage: UInt32 = 0
    var m_dwOffset_DropViewer: UInt32 = 0
    var m_dwOffset_DescriptionInSkillNote: UInt32 = 0
    var m_dwOffset_Stat: UInt32 = 0
    var m_dwOffset_BuffFactorIndices: UInt32 = 0
    var m_dwOffset_SpecialAbilityList: UInt32 = 0
    var m_dwOffset_SocketOptions: UInt32 = 0
    var m_dwOffset_AttachedParticleData: UInt32 = 0
    var m_dwOffset_AttachedMeshData: UInt32 = 0
    var m_dwOffset_Extra: UInt32 = 0
    var m_dwOffset_RandomSocketOptions: UInt32 = 0
    var m_dwOffset_StatRelationLevel: UInt32 = 0
    
    var m_sEndurance: Int16 = 0
    var m_sEnduranceDamageMin: Int16 = 0
    var m_sEnduranceDamageMax: Int16 = 0
    var m_usSummonNpcID: UInt16 = 0
    var m_byBuyPvpRankCondition: UInt8 = 0
    var m_byUseLevel: UInt8 = 0
    var m_byUnitType: UInt8 = 0
    var m_byUnitClass: UInt8 = 0
    var m_byBuffID: UInt8 = 0
    var m_byEqipPosition: UInt8 = 0
    var m_byCoolTime: UInt8 = 0
    var m_byMaxSealCount: UInt8 = 0
    var m_byMaxAttribEnchantCount: UInt8 = 0
    var m_byAttributeLevel: UInt8 = 0
    var m_byNumFrameOffsets: UInt8 = 0
    var m_byNumRenderScales: UInt8 = 0
    var m_byNumRenderRotates: UInt8 = 0
    var m_byNumCommonItemModelNames: UInt8 = 0
    var m_byNumCommonItemXETNames: UInt8 = 0
    var m_byNumSlashTraces: UInt8 = 0
    
    func fashion() -> Bool {
        getBit(EFlags.FLAG_BIT_FASHION)
    }
    
    func vested() -> Bool {
        getBit(EFlags.FLAG_BIT_VESTED)
    }
    
    func hideSetDesc() -> Bool {
        getBit(EFlags.FLAG_BIT_HIDE_SET_DESC)
    }
    
    func pvpItem() -> Bool {
        getBit2(EFlags2.FLAG_BIT_PVP_ITEM)
    }
    
    func canEnchant() -> Bool {
        getBit(EFlags.FLAG_BIT_CAN_ENCHANT)
    }
    
    func canUseInventory() -> Bool {
        getBit(EFlags.FLAG_BIT_CAN_USE_INVENTORY)
    }
    
    func noEquip() -> Bool {
        getBit(EFlags.FLAG_BIT_NO_EQUIP)
    }
    
    func isPCBang() -> Bool {
        getBit(EFlags.FLAG_BIT_IS_PC_BANG)
    }
    
    func canHyperMode() -> Bool {
        getBit(EFlags.FLAG_BIT_CAN_HYPER_MODE)
    }
    
    func useType() -> USE_TYPE {
        .init(rawValue: getValue(bitPos: EFlags.FLAG_POS_USE_TYPE, numBits: EFlags.FLAG_NUM_USE_TYPE))!
    }
    
    func useCondition() -> USE_CONDITION {
        .init(rawValue: getValue(bitPos: EFlags.FLAG_POS_USE_CONDITION, numBits: EFlags.FLAG_NUM_USE_CONDITION))!
    }
    
    func itemType() -> ITEM_TYPE {
        .init(rawValue: getValue(bitPos: EFlags.FLAG_POS_ITEM_TYPE, numBits: EFlags.FLAG_NUM_ITEM_TYPE))!
    }
    
    func itemGrade() -> ITEM_GRADE {
        .init(rawValue: getValue(bitPos: EFlags.FLAG_POS_ITEM_GRADE, numBits: EFlags.FLAG_NUM_ITEM_GRADE))!
    }
    
    func periodType() -> PERIOD_TYPE {
        .init(rawValue: getValue(bitPos: EFlags.FLAG_POS_PERIOD_TYPE, numBits: EFlags.FLAG_NUM_PERIOD_TYPE))!
    }
    
    func shopPriceType() -> SHOP_PRICE_TYPE {
        .init(rawValue: getValue(bitPos: EFlags.FLAG_POS_SHOP_PRICE_TYPE, numBits: EFlags.FLAG_NUM_SHOP_PRICE_TYPE))!
    }
    
    func buyPVPRankCondition() -> PVP_RANK {
        .init(rawValue: m_byBuyPvpRankCondition)!
    }
    
    func unitType() -> UNIT_TYPE {
        .init(rawValue: m_byUnitType)!
    }
    
    func unitClass() -> UNIT_CLASS {
        .init(rawValue: m_byUnitClass)!
    }
    
    func equipPosition() -> EQIP_POSITION {
        .init(rawValue: m_byEqipPosition)!
    }
    
    
    func getBit(_ bitPos: UInt32) -> Bool {
        return (m_dwFlags & (1 << bitPos)) != 0
    }
    
    func getBit2(_ bitPos: UInt32) -> Bool {
        return (m_dwFlags2 & (1 << bitPos)) != 0
    }
    
    func getValue(bitPos: UInt32, numBits: UInt32) -> UInt32 {
        return (m_dwFlags >> bitPos) & ((1 << numBits) - 1)
    }
}

struct EFlags {
    static let FLAG_BIT_FASHION: UInt32 = 0
    static let FLAG_BIT_VESTED: UInt32 = 1
    static let FLAG_BIT_CAN_ENCHANT: UInt32 = 2
    static let FLAG_BIT_CAN_USE_INVENTORY: UInt32 = 3
    static let FLAG_BIT_NO_EQUIP: UInt32 = 4
    static let FLAG_BIT_IS_PC_BANG: UInt32 = 5
    static let FLAG_BIT_CAN_HYPER_MODE: UInt32 = 6
    static let FLAG_BIT_HIDE_SET_DESC: UInt32 = 7
    static let FLAG_POS_USE_TYPE: UInt32 = 8
    static let FLAG_NUM_USE_TYPE: UInt32 = 4
    static let FLAG_POS_USE_CONDITION: UInt32 = 12
    static let FLAG_NUM_USE_CONDITION: UInt32 = 4
    static let FLAG_POS_ITEM_TYPE: UInt32 = 16
    static let FLAG_NUM_ITEM_TYPE: UInt32 = 4
    static let FLAG_POS_ITEM_GRADE: UInt32 = 20
    static let FLAG_NUM_ITEM_GRADE: UInt32 = 4
    static let FLAG_POS_PERIOD_TYPE: UInt32 = 24
    static let FLAG_NUM_PERIOD_TYPE: UInt32 = 4
    static let FLAG_POS_SHOP_PRICE_TYPE: UInt32 = 28
    static let FLAG_NUM_SHOP_PRICE_TYPE: UInt32 = 4
}

struct EFlags2 {
    static let FLAG_BIT_PVP_ITEM: UInt32 = 0
}
