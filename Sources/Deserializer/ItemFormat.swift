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
    
    func toSetItemData(with deserializer: Deserializer) -> [SetItemData] {
        let needPartsToOptions = convertToDictionary(items: getSetItemNeedPartsNumNOptions(from: deserializer.data))
        return needPartsToOptions.keys.sorted().map {
            SetItemData(m_SetID: m_dwSetID.toInt(),
                        m_SetName: deserializer.string(by: m_dwOffset_SetName),
                        m_mapNeedPartsNumNOptions: [$0: needPartsToOptions[$0] ?? []])
        }
    }
    
    func convertToDictionary(items: [KItemForamtNeedPartsNumAndOption]) -> [Int: [Int]] {
        var result: [Int: [Int]] = [:]
        
        for item in items {
            // 如果字典中已经有该键，则追加到数组中
            if var options = result[item.m_dwNeedPartsNum.toInt()] {
                options.append(item.m_iOption.toInt())
                result[item.m_dwNeedPartsNum.toInt()] = options
            } else {
                // 否则，创建一个新数组
                result[item.m_dwNeedPartsNum.toInt()] = [item.m_iOption.toInt()]
            }
        }
        
        return result
    }
}

struct KItemFormatTemplet {
    let m_dwItemID: UInt32
    let m_dwFlags: UInt32
    let m_dwFlags2: UInt32
    let m_iItemLevel: Int32
    let m_iQuantity: Int32
    let m_fRepairED: Float
    let m_iRepairVP: Int32
    let m_iPrice: Int32
    let m_iPricePvPPoint: Int32
    let m_iSetID: Int32
    let m_fAddMaxMP: Float
    
    let m_dwOffset_Name: UInt32
    let m_dwOffset_Description: UInt32
    let m_dwOffset_DescriptionInShop: UInt32
    let m_adwOffset_AttachFrameName: (UInt32, UInt32, UInt32, UInt32, UInt32, UInt32)
    let m_adwOffset_ModelName: (UInt32, UInt32, UInt32, UInt32, UInt32, UInt32)
    let m_dwOffset_TextureChangeXETName: UInt32
    let m_dwOffset_AniXETName: UInt32
    let m_dwOffset_AniName: UInt32
    let m_dwOffset_ShopImage: UInt32
    let m_dwOffset_DropViewer: UInt32
    let m_dwOffset_DescriptionInSkillNote: UInt32
    let m_dwOffset_Stat: UInt32
    let m_dwOffset_BuffFactorIndices: UInt32
    let m_dwOffset_SpecialAbilityList: UInt32
    let m_dwOffset_SocketOptions: UInt32
    let m_dwOffset_AttachedParticleData: UInt32
    let m_dwOffset_AttachedMeshData: UInt32
    let m_dwOffset_Extra: UInt32
    let m_dwOffset_RandomSocketOptions: UInt32
    let m_dwOffset_StatRelationLevel: UInt32
    
    let m_sEndurance: Int16
    let m_sEnduranceDamageMin: Int16
    let m_sEnduranceDamageMax: Int16
    let m_usSummonNpcID: UInt16
    let m_byBuyPvpRankCondition: UInt8
    let m_byUseLevel: UInt8
    let m_byUnitType: UInt8
    let m_byUnitClass: UInt8
    let m_byBuffID: UInt8
    let m_byEqipPosition: UInt8
    let m_byCoolTime: UInt8
    let m_byMaxSealCount: UInt8
    let m_byMaxAttribEnchantCount: UInt8
    let m_byAttributeLevel: UInt8
    let m_byNumFrameOffsets: UInt8
    let m_byNumRenderScales: UInt8
    let m_byNumRenderRotates: UInt8
    let m_byNumCommonItemModelNames: UInt8
    let m_byNumCommonItemXETNames: UInt8
    let m_byNumSlashTraces: UInt8
    
    func toItemTemplate(with deserializer: Deserializer) -> ItemTemplet {
        .init(m_ItemID: m_dwItemID.toInt(),
              m_Name: deserializer.string(by: m_dwOffset_Name),
              m_Description: deserializer.string(by: m_dwOffset_Description),
              m_DescriptionInShop: deserializer.string(by: m_dwOffset_DescriptionInShop),
              m_ModelName: [deserializer.string(by: m_adwOffset_ModelName.0),
                            deserializer.string(by: m_adwOffset_ModelName.1)],
              m_TextureChangeXETName: deserializer.string(by: m_dwOffset_TextureChangeXETName),
              m_AniXETName: deserializer.string(by: m_dwOffset_AniXETName),
              m_AniName: deserializer.string(by: m_dwOffset_AniName),
              m_ShopImage: deserializer.string(by: m_dwOffset_ShopImage),
              m_DropViewer: deserializer.string(by: m_dwOffset_DropViewer),
              m_ItemType: itemType(),
              m_ItemGrade: itemGrade(),
              m_bFashion: fashion(),
              m_bVested: vested(),
              m_bCanEnchant: canEnchant(),
              m_bCanUseInventory: canUseInventory(),
              m_bNoEquip: noEquip(),
              m_bIsPcBang: isPCBang(),
              m_iItemLevel: m_iItemLevel.toInt(),
              m_ucMaxSealCount: m_byMaxSealCount.toInt(),
              m_iMaxAttribEnchantCount: m_byMaxAttribEnchantCount.toInt(),
              m_UseType: useType(),
              m_AttachFrameName: [deserializer.string(by: m_adwOffset_AttachFrameName.0),
                                  deserializer.string(by: m_adwOffset_AttachFrameName.1)],
              m_bCanHyperMode: canHyperMode(),
              m_PeriodType: periodType(),
              m_Endurance: m_sEndurance.toInt(),
              m_EnduranceDamageMin: m_sEnduranceDamageMin.toInt(),
              m_EnduranceDamageMax: m_sEnduranceDamageMax.toInt(),
              m_RepairED: m_fRepairED,
              m_RepairVP: m_iRepairVP.toInt(),
              m_Quantity: m_iQuantity.toInt(),
              m_PriceType: shopPriceType(),
              m_Price: m_iPrice.toInt(),
              m_PricePvPPoint: m_iPricePvPPoint.toInt(),
              m_UseCondition: useCondition(),
              m_UnitType: unitType(),
              m_UnitClass: unitClass(),
              m_UseLevel: m_byUseLevel.toInt(),
              m_BuyPvpRankCondition: buyPVPRankCondition(),
              m_EqipPosition: equipPosition(),
              m_Stat: stat(with: deserializer),
              m_SpecialAbilityList: specialAbilityList(with: deserializer),
              m_vecSocketOption: socketOptions(with: deserializer),
              m_vecRandomSocketGroupID: randomSocketGroup(with: deserializer),
              m_kStatRelationLevel: statRelLV(with: deserializer),
              m_CoolTime: m_byCoolTime.toInt(),
              m_SetID: m_iSetID.toInt(),
              m_iAttributeLevel: m_byAttributeLevel.toInt(),
              m_iBuffFactorID: buffactorID(with: deserializer).toInt())
    }
   
    func buffactorID(with deserializer: Deserializer) -> UInt16 {
        guard m_dwOffset_BuffFactorIndices != 0 else { return 0 }
        let num = deserializer.data.withUnsafeBytes { ptr in
            ptr.load(fromByteOffset: Int(m_dwOffset_BuffFactorIndices), as: UInt16.self)
        }
        return num
    }
    
    func statRelLV(with deserializer: Deserializer) -> SStatRelationLevel {
        guard m_dwOffset_StatRelationLevel != 0 else { return .init() }
        return deserializer.data.withUnsafeBytes { ptr in
            let format = ptr.load(fromByteOffset: Int(m_dwOffset_Stat), as: KItemFormatStatRelLVData.self)
            return .init(format: format)
        }
    }
    
    func randomSocketGroup(with deserializer: Deserializer) -> [Int] {
        guard m_dwOffset_RandomSocketOptions != 0 else { return [] }
        let bData = deserializer.data.advanced(by: Int(m_dwOffset_RandomSocketOptions))
        let dwNum = bData.withUnsafeBytes { $0.load(as: UInt32.self) }
        
        var randomSocketGroup = [Int]()
        for i in 0..<dwNum {
            let data = bData.advanced(by: dwordSize + intSize * Int(i))
            let randomSocket = data.withUnsafeBytes { $0.load(as: Int32.self) }
            randomSocketGroup.append(Int(randomSocket))
        }
        return randomSocketGroup
    }
    
    func socketOptions(with deserializer: Deserializer) -> [Int] {
        guard m_dwOffset_SocketOptions != 0 else { return [] }
        let bData = deserializer.data.advanced(by: Int(m_dwOffset_SocketOptions))
        let dwNum = bData.withUnsafeBytes { $0.load(as: UInt32.self) }
        
        var options = [Int]()
        for i in 0..<dwNum {
            let data = bData.advanced(by: dwordSize + intSize * Int(i))
            let option = data.withUnsafeBytes { $0.load(as: Int32.self) }
            options.append(Int(option))
        }
        return options
    }
    
    func specialAbilityList(with deserializer: Deserializer) -> [SpecialAbility] {
        guard m_dwOffset_SpecialAbilityList != 0 else { return [] }
        let bData = deserializer.data.advanced(by: Int(m_dwOffset_SpecialAbilityList))
        let dwNum = bData.withUnsafeBytes { $0.load(as: UInt32.self) }
        
        var abilities = [SpecialAbility]()
        for i in 0..<dwNum {
            let data = bData.advanced(by: dwordSize + MemoryLayout<KItemFormatSpecialAbility>.size * Int(i))
            let item = data.withUnsafeBytes { $0.load(as: KItemFormatSpecialAbility.self) }
            abilities.append(.init(format: item))
        }
        return abilities
    }
    
    func stat(with deserializer: Deserializer) -> Stat {
        guard m_dwOffset_Stat != 0 else { return .init() }
        return deserializer.data.withUnsafeBytes { ptr in
            let format = ptr.load(fromByteOffset: Int(m_dwOffset_Stat), as: KItemFormatStatData.self)
            return .init(format: format)
        }
    }
    
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
    
    
    private func getBit(_ bitPos: UInt32) -> Bool {
        return (m_dwFlags & (1 << bitPos)) != 0
    }
    
    private func getBit2(_ bitPos: UInt32) -> Bool {
        return (m_dwFlags2 & (1 << bitPos)) != 0
    }
    
    private func getValue(bitPos: UInt32, numBits: UInt32) -> UInt32 {
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
