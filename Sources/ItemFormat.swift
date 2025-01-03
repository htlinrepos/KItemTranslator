//
//  ItemKim.swift
//  DecryptElsword
//
//  Created by Erwin Lin on 1/1/25.
//

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
    var m_CoolTime: Int = 0
    var m_Value1: Int = 0
    var m_Value2: Int = 0
    var m_Value3: Int = 0
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
    var m_iOption: Int = 0
}

struct KItemFormatSetItemData {
    var m_dwSetID: UInt32 = 0
    var m_iMaxLevel: Int = 0
    var m_dwOffset_SetName: UInt32 = 0
    var m_dwOffset_ItemIDs: UInt32 = 0
    var m_dwOffset_NeedPartsNumNOptions: UInt32 = 0
}

struct KItemFormatTemplet {
    var m_dwItemID: UInt32 = 0
    var m_dwFlags: UInt32 = 0
    var m_dwFlags2: UInt32 = 0
    var m_iItemLevel: Int = 0
    var m_iQuantity: Int = 0
    var m_fRepairED: Float = 0
    var m_iRepairVP: Int = 0
    var m_iPrice: Int = 0
    var m_iPricePvPPoint: Int = 0
    var m_iSetID: Int = 0
    var m_fAddMaxMP: Float = 0
    var m_dwOffset_Name: UInt32 = 0
    var m_dwOffset_Description: UInt32 = 0
    var m_dwOffset_DescriptionInShop: UInt32 = 0
    var m_adwOffset_AttachFrameName: [UInt32] = Array(repeating: 0, count: MAX_MODEL_COUNT_A_ITEM)
    var m_adwOffset_ModelName: [UInt32] = Array(repeating: 0, count: MAX_MODEL_COUNT_A_ITEM)
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
}

struct EFlags {
    static let FLAG_BIT_FASHION = 0
    static let FLAG_BIT_VESTED = 1
    static let FLAG_BIT_CAN_ENCHANT = 2
    static let FLAG_BIT_CAN_USE_INVENTORY = 3
    static let FLAG_BIT_NO_EQUIP = 4
    static let FLAG_BIT_IS_PC_BANG = 5
    static let FLAG_BIT_CAN_HYPER_MODE = 6
    static let FLAG_BIT_HIDE_SET_DESC = 7
    static let FLAG_POS_USE_TYPE = 8
    static let FLAG_NUM_USE_TYPE = 4
    static let FLAG_POS_USE_CONDITION = 12
    static let FLAG_NUM_USE_CONDITION = 4
    static let FLAG_POS_ITEM_TYPE = 16
    static let FLAG_NUM_ITEM_TYPE = 4
    static let FLAG_POS_ITEM_GRADE = 20
    static let FLAG_NUM_ITEM_GRADE = 4
    static let FLAG_POS_PERIOD_TYPE = 24
    static let FLAG_NUM_PERIOD_TYPE = 4
    static let FLAG_POS_SHOP_PRICE_TYPE = 28
    static let FLAG_NUM_SHOP_PRICE_TYPE = 4
}

struct EFlags2 {
    static let FLAG_BIT_PVP_ITEM = 0
}
