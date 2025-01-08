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
              m_iBuffFactorID: buffactorID(with: deserializer))
    }
   
    func buffactorID(with deserializer: Deserializer) -> BUFF_FACTOR_ID {
        guard m_dwOffset_BuffFactorIndices != 0 else { return .BFI_NONE }
        let data = deserializer.data.advanced(by: Int(m_dwOffset_BuffFactorIndices))
        let num = data.withUnsafeBytes { ptr in
            ptr.load(as: UInt16.self)
        }
        
        guard num > 0 else { return .BFI_NONE }
        
        let id = data.withUnsafeBytes { ptr in
            ptr.load(fromByteOffset: 2, as: UInt16.self)
        }
        
        return .init(rawValue: Int(id)) ?? .BFI_NONE
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

enum BUFF_FACTOR_ID: Int, Encodable {
    case BFI_SI_P_AEM_ELEMENTAL_FRIENDSHIP_ATTACK = 254
    case BFI_DEBUFF_ATTRIBUTE_DEFENCE = 249
    case BFI_SI_A_EEG_METAL_DUST_AURA_MEMO = 39
    case BFI_DEBUFF_ENTANGLE = 69
    case BFI_DEBUFF_LTR_ENTANGLE = 241
    case BFI_BUFF_ELIXIR_ICE_BALL_OF_DENIPH = 190
    case BFI_BUFF_GATE_DEFENCE = 184
    case BFI_DEBUFF_ARMOR_BREAK_MEMO = 71
    case BFI_UNO_SHOW_TIME = 180
    case BFI_BUFF_WALDO_TROCK = 144
    case BFI_BUFF_2013_DEFENSE_BUFF_EVENT = 197
    case BFI_BUFF_ELRIN = 207
    case BFI_BUFF_AMPLIFICATION_PLACE = 47
    case BFI_BUFF_HYPER_MODE_MEDICINE = 66
    case BFI_DEBUFF_BIND = 73
    case BFI_BUFF_2013_DEFENSE_DEBUFF = 196
    case BFI_BUFF_PET_AURA_SKILL_LEVEL_2_100 = 134
    case BFI_COMMON_AURA_EL_DEFENCE_ACCEL = 214
    case BFI_BUFF_2013_DEFENSE_FAKE_BUFF = 194
    case BFI_NPC_MAGIC_DEFENCE_ACCEL = 6
    case BFI_BUFF_SWORD_ENCHANT_POISON = 164
    case BFI_DEBUFF_WEAPON_BREAK = 42
    case BFI_BUFF_ELIXIR_BLAZING_BOMB = 187
    case BFI_DEBUFF_FLAME_SWORD = 301
    case BFI_BUFF_ELIXIR_CRADLE_OF_LITTLE_FAIRY = 189
    case BFI_SHADOW_BODY = 219
    case BFI_STONE_GOD_TIRED = 178
    case BFI_DEBUFF_SI_A_LWS_NATURE_FORCE_MEMO = 123
    case BFI_BUFF_PET_AURA_SKILL_LEVEL_3_DEFAULT = 135
    case BFI_CALM_REST = 78
    case BFI_BUFF_HENIR_NATURE = 149
    case BFI_BUFF_SECRET_SET_EQUIP_MANA_RECOVERY_VALUE_02 = 170
    case BFI_BUFF_WATER_SHIELD = 265
    case BFI_DEBUFF_BIND_WITH_MEMO = 74
    case BFI_BUFF_BELSSING_OF_CRONOS = 97
    case BFI_SI_SA_COMMON_MAGIC_ACCEL = 8
    case BFI_PVP_HERO_NPC_PHYSIC_ATTACK_ACCEL = 140
    case BFI_BUFF_PREMIUM_PC_ROOM = 124
    case BFI_SI_P_COMMON_REVERSAL_SOLDIER = 21
    case BFI_DEBUFF_PARTICLE_PRISM_USE_MUTATION_POINT = 352
    case BFI_BUFF_WARM_ENERGE_OF_EL = 103
    case BFI_DEBUFF_SWORD_SHIELD_WOUND = 323
    case BFI_BUFF_CHANCE_TO_REVERSE = 54
    case BFI_BUFF_PVP_REVENGE_MODE_LEVEL_2 = 112
    case BFI_BUFF_SWORD_ENCHANT_POISON_MEMO = 340
    case BFI_DEBUFF_MOVE_JUMP_SLOWDOWN_LEG_SHOT = 55
    case BFI_SI_P_AEM_ENERGY_OF_THE_PLENTY_2 = 15
    case BFI_BUFF_GALE_APPLE = 203
    case BFI_BUFF_RALLY_OF_HERO_LEVEL_3 = 101
    case BFI_BUFF_HENIR_FIRE = 147
    case BFI_DEBUFF_MARK_OF_COMMANDER_MEMO = 57
    case BFI_BUFF_LAND_DIMOLISHER = 50
    case BFI_BUFF_SECRET_SET_EQUIP_MANA_RECOVERY_VALUE_03 = 171
    case BFI_SI_A_ES_ENDURANCE_MEMO = 19
    case BFI_BUFF_PET_AURA_SKILL_LEVEL_2_DEFAULT = 130
    case BFI_COMMON_AURA_CRITICAL_ACCEL = 215
    case BFI_DEBUFF_BRUTAL_PIERCING = 157
    case BFI_DEBUFF_MARK_OF_COMMANDER = 56
    case BFI_BUFF_DWARF_MEDICINE = 60
    case BFI_BUFF_GALE_WAY_OF_SWORD = 237
    case BFI_DEBUFF_SI_A_AHM_MEDITATION = 88
    case BFI_VITAL_POINT_STAB = 29
    case BFI_DEBUFF_SELF_PROTECTION_FORTITUDE = 264
    case BFI_DEBUFF_SWORD_ENCHANT_ICE = 165
    case BFI_DEBUFF_HELLFIRE_GATLING_MEMO = 342
    case BFI_DEBUFF_SWORD_FIRE = 2
    case BFI_DEBUFF_ATTACK_ALL_TEAM = 76
    case BFI_BUFF_WONDER_WALL_MEMO = 52
    case BFI_BUFF_FIELD_DEFENCE = 182
    case BFI_HYPER_MODE = 1
    case BFI_BUFF_KELAINO_RAGE_MODE = 155
    case BFI_NPC_RED_POTION = 27
    case BFI_BUFF_PROTECTION_CREST = 63
    case BFI_DEBUFF_PANDEMONIUM_FEAR = 212
    case BFI_BUFF_MECHANIZATION_SPEED_UP = 141
    case BFI_BUFF_TROCKTA_MAGICATTACKB_PRESS = 174
    case BFI_BUFF_CRITICAL_SWORD = 236
    case BFI_BUFF_PROTECTION_OF_ZACHIEL = 93
    case BFI_BUFF_GLITER_BLUE_DEFENCE_UP = 303
    case BFI_DEBUFF_MAGIC_DEFFENCE_DROP = 72
    case BFI_BUFF_CHOA = 210
    case BFI_SI_P_EIS_LIGHTNING_STEP = 81
    case BFI_DEBUFF_KALLVEROS_TIRED = 179
    case BFI_BUFF_GIANT_MEDICINE = 58
    case BFI_BUFF_BELSSING_OF_AMON = 96
    case BFI_BUFF_ENDURANCE_POWER = 232
    case BFI_SI_A_EEG_METAL_DUST_AURA = 38
    case BFI_DEBUFF_ESK_WEAPON_BREAK = 234
    case BFI_DEBUFF_IGNITION_CROW_INCINERATION_BURN = 242
    case BFI_BUFF_HERO_OF_ELIOS_LEVEL_4 = 110
    case BFI_DEBUFF_HIGH_KICK = 225
    case BFI_DEBUFF_REST_OF_RELLY = 102
    case BFI_SHADOW_DEFENDER_BARRIER = 35
    case BFI_BUFF_WEY = 211
    case BFI_DEBUFF_FATE_SPACE = 256
    case BFI_BUFF_DODGE_AND_SLASH_AVOIDANCE = 230
    case BFI_BUFF_APRIL_FOOLSDAY = 183
    case BFI_ELESIS_SWORD_ERUPTION_STUN_MEMO = 336
    case BFI_BUFF_SI_A_ALD_REFLECTION = 259
    case BFI_DEBUFF_FATAL_SLAP = 252
    case BFI_BUFF_HERO_OF_ELIOS_LEVEL_1 = 107
    case BFI_DEBUFF_SI_A_ALD_FINGER_BULLET = 260
    case BFI_MAGIC_POINT_IMMEDIATELY_CHANGE_ONCE_DOWN = 262
    case BFI_SET_SKILL_COOLTIME_ONCE_TO_MIN = 263
    case BFI_SI_SA_COMMON_POWER_ACCEL = 7
    case BFI_DEBUFF_SWORD_ENCHANT_POISON = 167
    case BFI_BUFF_POWER_EXCHANGER_HALF_DOWN = 357
    case BFI_DEBUFF_SUPPRESSION = 160
    case BFI_ENERGETIC_BODY = 220
    case BFI_BUFF_SWORD_ENCHANT_FIRE = 163
    case BFI_BUFF_SET_OPTION_DECREASE_DAMAGE_20_SECONDS = 270
    case BFI_BUFF_SET_OPTION_CRITICAL_DAMAGE_20_PERCENT = 272
    case BFI_BUFF_LIBRARY_OF_LIMITLESS_MANA_RECOVERY = 346
    case BFI_DEBUFF_CUTTING_SWORD = 228
    case BFI_BUFF_SET_OPTION_ADD_ENCHANT_RATE_LARGE = 276
    case BFI_SHINING_BODY = 218
    case BFI_BUFF_BUGI_TROCK = 145
    case BFI_BUFF_HENIR_WATER = 148
    case BFI_DEBUFF_SI_SA_ELK_SAND_STORM = 118
    case BFI_DEBUFF_SET_OPTION_CURSE = 277
    case BFI_SI_SA_RBM_GIGA_DRIVE = 24
    case BFI_DEBUFF_SET_OPTION_COLD_5_SECONDS = 279
    case BFI_BUFF_HENIR_WIND = 150
    case BFI_BUFF_HAMEL_SECRET_DUNGEON_WING = 281
    case BFI_DEBUFF_SET_OPTION_FIRE = 283
    case BFI_BUFF_SHASHA_HEAL_STAGE1TO3 = 284
    case BFI_BUFF_HP_RECOVERY = 289
    case BFI_DEBUFF_POWERFUL_BOWSTRING = 142
    case BFI_DEBUFF_PROVOKE = 293
    case BFI_BUFF_FIRE_BLOSSOMS_APPLY = 296
    case BFI_DEBUFF_BACK_KICK = 226
    case BFI_BUFF_HENIR_LIGHT = 151
    case BFI_BUFF_WAR_PRELUDE = 298
    case BFI_DEBUFF_HIGH_FEVER = 300
    case BFI_BUFF_ELIXIR_GIANT_POTION = 186
    case BFI_BUFF_ANTIMAGIC_CREST = 64
    case BFI_DEBUFF_ANCIENT_FIRE_DUNGEON = 304
    case BFI_BUFF_WHEN_RIDE_ON_PET_FOR_ONLY_MASTER_FIX = 306
    case BFI_SI_P_ETK_BRUTAL_SLAYER = 20
    case BFI_BUFF_GLITER_RED_TENTION_UP = 309
    case BFI_BUFF_SA_ESK_WINDMILL = 314
    case BFI_FORMATION_MODE = 315
    case BFI_DEBUFF_STIGMA = 41
    case BFI_SI_SA_COMMON_SHIELD_ADRENALIN = 12
    case BFI_BUFF_BLAZE_STEP = 316
    case BFI_TRAPPINGARROW_FUNGUS_DEBUFF = 317
    case BFI_BUFF_ANNIHILATION_SUPER_ARMOR = 248
    case BFI_DEBUFF_SUMMON_BAT_HEAVY_DOLL = 318
    case BFI_SI_A_AV_MANA_SHIELD_MEMO = 319
    case BFI_NPC_PHYSIC_DEFENCE_ACCEL = 4
    case BFI_SI_SA_ESK_ARMAGEDON_BLADE = 25
    case BFI_SI_SA_ESK_ARMAGEDON_BLADE_MEMO = 321
    case BFI_DEBUFF_JUDGEMENT_FIRE = 292
    case BFI_SI_SA_ESK_ARMAGEDON_BLADE_HYPER_MEMO = 322
    case BFI_BUFF_SET_OPTION_ADD_ENCHANT_RATE_MEDIUM = 275
    case BFI_BUFF_HAMEL_SECRET_DUNGEON_WING_EVENT = 366
    case BFI_DEBUFF_SWORD_SHIELD_BLEEDING = 235
    case BFI_DEBUFF_SWORD_FIRE_ATTACK = 325
    case BFI_PROTECTION_OF_EARTH = 22
    case BFI_DEBUFF_JUDGEMENT_FIRE2 = 307
    case BFI_BUFF_BREAKING_MEMO = 181
    case BFI_DEBUFF_SWORD_FIRE_ATTACK_MEMO = 326
    case BFI_DEBUFF_BLEEDING_PLASMA_CUTTER_MEMO = 328
    case BFI_SI_SA_EMK_SWORD_FIRE = 44
    case BFI_DEBUFF_ARMOR_CRASH_MEMO = 330
    case BFI_NONE = 0
    case BFI_DEBUFF_PANDEMONIUM_FEAR_MEMO = 332
    case BFI_BUFF_SI_A_ALD_REFLECTION_MEMO = 334
    case BFI_BUFF_SI_SA_EBS_ENERGETIC_HEART = 87
    case BFI_ELESIS_ENDURANCE_MEMO = 335
    case BFI_BUFF_SI_A_AHM_MEDITATION_PVP = 288
    case BFI_BUFF_KUMI = 209
    case BFI_BUFF_SUPER_ARMOR = 143
    case BFI_SET_SKILL_COOLTIME_ONCE_TO_MAX = 258
    case BFI_BUFF_POWER_OF_TIGER = 223
    case BFI_DEBUFF_DEATH_SENTENCE = 75
    case BFI_BUFF_HERO_OF_ELIOS_LEVEL_3 = 109
    case BFI_DEBUFF_LOW_KICK = 227
    case BFI_DEBUFF_LTR_ENTANGLE_MEMO = 341
    case BFI_DEBUFF_SI_A_RST_CUT_TENDON = 115
    case BFI_SI_A_ERS_SWORD_ENCHANT = 45
    case BFI_SI_SA_COMMON_SPEED_ACCEL = 13
    case BFI_DEBUFF_HENIR_FIRE = 152
    case BFI_BUFF_SGM_VICTORIOUS_SWORD = 345
    case BFI_DEBUFF_SET_OPTION_DEADLY_POISON = 273
    case BFI_DEBUFF_EMP_SHOCK_FAR = 349
    case BFI_BUFF_HARSH_SLAYER_SPECIAL = 244
    case BFI_BUFF_HAMEL_SECRET_DUNGEON_WEAPON = 282
    case BFI_DEBUFF_PARTICLE_PRISM = 351
    case BFI_BUFF_PET_AURA_SKILL_LEVEL_2_80 = 132
    case BFI_DEBUFF_WIND_WEDGE_BLEEDING = 312
    case BFI_DEBUFF_SI_SA_ERS_LUNA_BLADE = 117
    case BFI_BUFF_NATURAL_FORCE = 355
    case BFI_NPC_ALCHEMYST_SECRET_BOSS_TRANSFORM_SCALE = 28
    case BFI_BUFF_POWER_EXCHANGER_HALF_UP = 356
    case BFI_BUFF_SHASHA_HEAL_STAGE0 = 266
    case BFI_DEBUFF_PLASMA_LINK = 358
    case BFI_BUFF_QUICKSILVER_FRENZY = 359
    case BFI_SI_A_LWS_NATURE_FORCE = 23
    case BFI_DEBUFF_PURGE = 360
    case BFI_BUFF_WONDER_WALL = 51
    case BFI_BUFF_BELSSING_OF_GEB = 95
    case BFI_DEBUFF_SI_P_EIS_MIND_OF_FIGHTER = 80
    case BFI_BUFF_NAVER = 361
    case BFI_BUFF_THE_ESSENCE_OF_WEAK_HERETIC_POTION = 362
    case BFI_SI_P_ADW_ADVANCED_TELEPORTATION = 83
    case BFI_BUFF_THE_ESSENCE_OF_HERETIC_POTION = 363
    case BFI_BUFF_SET_OPTION_CRITICAL_DAMAGE_5_PERCENT = 310
    case BFI_BUFF_FIGHTING_SPIRIT_POTION = 204
    case BFI_DEBUFF_POISON_SET_EQUIP_OPTION = 168
    case BFI_BUFF_RURIEL_MANA_ENERGIZE_POTION = 364
    case BFI_NASOD_ARMOR = 353
    case BFI_BUFF_HAMEL_SECRET_DUNGEON_ARMOR_EVENT = 365
    case BFI_DEBUFF_LOW_KICK_MEMO = 343
    case BFI_BUFF_PET_AURA_SKILL_LEVEL_1_90 = 128
    case BFI_SI_SA_COMMON_SHIELD_ACCEL = 9
    case BFI_ARA_FULL_HYPER_MODE = 156
    case BFI_DEBUFF_UNEXTINGUISHABLE_FIRE = 294
    case BFI_DEBUFF_REST_OF_RECHALLENGE = 308
    case BFI_BUFF_SWORD_ENCHANT_FIRE_MEMO = 339
    case BFI_SI_SA_ABM_MAGICAL_MAKEUP_MEMO = 324
    case BFI_BUFF_CHIVALRY_DEFENCE = 222
    case BFI_BUFF_STONE_APPLE = 201
    case BFI_DEBUFF_PANIC_PANDEMONIUM = 49
    case BFI_BUFF_SWORD_ENCHANT_ICE = 162
    case BFI_BUFF_PROTECTION_OF_NUT = 90
    case BFI_NPC_MAGIC_ATTACK_ACCEL = 5
    case BFI_DEBUFF_ICE_STORM = 253
    case BFI_BUFF_2013_DEFENSE_BUFF = 195
    case BFI_DEBUFF_DELETE_ALCHEMYST_BOSS_SHEILD = 287
    case BFI_BUFF_UNFIXED_CLIP = 53
    case BFI_BLOODY_WEAPON = 31
    case BFI_DEBUFF_HENIR_WATER = 153
    case BFI_BLOODY_WEAPON_MEMO = 329
    case BFI_BUFF_POWER_OF_WHITE_TIGER = 158
    case BFI_DEBUFF_SI_SA_ADM_AGING = 120
    case BFI_DEBUFF_MIDDLE_KICK_MEMO = 251
    case BFI_SI_A_ES_ENDURANCE = 18
    case BFI_BUFF_SI_A_ASD_LOW_BRANDISH = 159
    case BFI_NPC_PHYSIC_ATTACK_ACCEL = 3
    case BFI_SI_A_AV_MANA_SHIELD = 34
    case BFI_BUFF_INCREASE_ALL_DEFENCE = 267
    case BFI_COMMON_AURA_ADDATK_ACCEL = 216
    case BFI_SI_P_RVC_SURVIVAL_TECHNIQUE_OF_MERCENARY = 85
    case BFI_BUFF_SI_SA_CTT_TACTICAL_FIELD_RAID = 213
    case BFI_BUFF_VICTORIOUS_SWORD = 233
    case BFI_FESTIVAL_EVENT_BUFF = 200
    case BFI_BUFF_RALLY_OF_HERO_LEVEL_2 = 100
    case BFI_BUFF_HAMEL_SECRET_DUNGEON_ARMOR = 280
    case BFI_BUFF_SUPER_AMOR_CREST = 65
    case BFI_BUFF_SET_OPTION_DECREASE_DAMAGE_10_SECONDS = 269
    case BFI_DEBUFF_STIGMA_OF_FIRE = 291
    case BFI_BUFF_PVP_REVENGE_MODE_LEVEL_1 = 111
    case BFI_DEBUFF_SET_OPTION_COLD_3_SECONDS = 278
    case BFI_DEBUFF_SET_OPTION_WOUND = 268
    case BFI_DEBUFF_MIND_BREAK = 347
    case BFI_BUFF_BLAZE_STEP_MEMO = 327
    case BFI_SI_SA_ESK_ARMAGEDON_BLADE_HYPER = 26
    case BFI_BUFF_PVP_REVENGE_MODE_LEVEL_3 = 113
    case BFI_BUFF_SWORD_ENCHANT_ICE_MEMO = 338
    case BFI_BUFF_SPRINTER_MEDICINE = 59
    case BFI_DEBUFF_WEAPON_CRASH = 255
    case BFI_BUFF_TROCKTA_TRAP = 176
    case BFI_BUFF_TROCKTA_HP_DRAIN = 175
    case BFI_DEBUFF_HARSH_SLAYER = 238
    case BFI_DEBUFF_WHITE_TIGER_MEMO = 333
    case BFI_BUFF_VITALITY_OF_EL = 122
    case BFI_EMPTY_EXP_BUFF = 154
    case BFI_DEBUFF_TELEPORT_CONSUME_MP = 290
    case BFI_BUFF_ANGER_OF_UOOL = 177
    case BFI_DEBUFF_MIDDLE_KICK = 239
    case BFI_BUFF_AIRELINNA_NYMPH = 240
    case BFI_SI_SA_ETK_PHANTOM_SWORD = 30
    case BFI_BUFF_OVER_HEAT_ENHANCE = 217
    case BFI_BUFF_THANKS_OF_RESIDENTS = 104
    case BFI_BUFF_HARSH_SLAYER_ACTIVE = 243
    case BFI_BUFF_AIRELINNA_SYLPH = 224
    case BFI_BUFF_TRADE_BLOCK = 205
    case BFI_BUFF_CHIVALRY_ATTACK = 221
    case BFI_BUFF_SI_A_AHM_MEDITATION = 36
    case BFI_DEBUFF_ARMOR_BREAK = 70
    case BFI_SI_P_AEM_ENERGY_OF_THE_PLENTY_1 = 14
    case BFI_BUFF_MAGICAL_CREST = 62
    case BFI_BUFF_ELIXIR_FEATHER_OF_VENTUS = 191
    case BFI_SI_SA_EEG_ATOMIC_SHIELD = 313
    case BFI_DEBUFF_SUPPRESSION_STUN = 311
    case BFI_SI_SA_ETK_PHANTOM_SWORD_MEMO = 344
    case BFI_BUFF_ELIXIR_BIG_HAND_POTION = 193
    case BFI_BUFF_WHEN_RIDE_ON_PET_FOR_ONLY_MASTER = 198
    case BFI_BUFF_ALCHEMYST_BOSS_SHIELD = 286
    case BFI_BUFF_GIANT_APPLE = 202
    case BFI_BUFF_BELSSING_OF_SERAPHIM = 94
    case BFI_BUFF_FIRE_BLOSSOMS_APPLY2 = 297
    case BFI_BUFF_KARUSO_BATTLE_MASTER_AWAKE = 172
    case BFI_DEBUFF_BLEEDING = 146
    case BFI_BUFF_GALE_MP_GAIN_INCREASE = 245
    case BFI_BUFF_FLAME_SWORD = 299
    case BFI_BUFF_BLESSING_OF_EL = 106
    case BFI_BUFF_OVER_HEAT = 84
    case BFI_DEBUFF_SIDE_EFFECT_CREST = 68
    case BFI_BUFF_PET_AURA_SKILL_LEVEL00 = 129
    case BFI_SI_SA_EMK_PHOENIX_TALON = 46
    case BFI_MAGIC_POINT_IMMEDIATELY_CHANGE_ONCE_UP = 257
    case BFI_BUFF_PET_AURA_SKILL_LEVEL_3_100 = 139
    case BFI_SI_SA_CSG_SHARPSHOOTER_SYNDROME = 40
    case BFI_BUFF_SUPER_AMOR_FOR_RIDING = 199
    case BFI_BUFF_2013_DEFENCE_ENTER_100_PERCENT_BUFF = 302
    case BFI_BUFF_ENEMY_GATE_DEFENCE = 185
    case BFI_DEBUFF_ARMOR_DESTROY = 231
    case BFI_DEBUFF_DOUBLE_ATTACK = 119
    case BFI_DEBUFF_WEAPON_BREAK_MEMO = 43
    case BFI_SI_SA_COMMON_POWER_ADRENALIN = 10
    case BFI_DEBUFF_BLIND_SMOKE = 77
    case BFI_DEBUFF_ESK_WEAPON_BREAK_MEMO = 320
    case BFI_BUFF_ANNIHILATION_WAY_OF_SWORD_PVP = 247
    case BFI_BUFF_PET_AURA_SKILL_LEVEL_1_DEFAULT = 125
    case BFI_BUFF_ELIXIR_FLAME_RING_OF_ROSSO = 192
    case BFI_BUFF_SPECTRUM_PLACE = 48
    case BFI_BUFF_BREATH_OF_DRAGON = 105
    case BFI_SI_SA_COMMON_MAGIC_ADRENALIN = 11
    case BFI_BUFF_ANNIHILATION_WAY_OF_SWORD = 246
    case BFI_BUFF_SECRET_SET_EQUIP_MANA_RECOVERY_VALUE_01 = 169
    case BFI_DEBUFF_SI_SA_ADW_IMPACT_HAMMER = 82
    case BFI_DEBUFF_SI_SA_EIS_RAGE_CUTTER = 79
    case BFI_BUFF_TROCKTA_MAGICATTACKB_STUN = 173
    case BFI_BUFF_SET_OPTION_CRITICAL_DAMAGE_10_PERCENT = 271
    case BFI_BUFF_RETURN_OF_HERO = 114
    case BFI_SI_P_AEM_ELEMENTAL_FRIENDSHIP = 37
    case BFI_HELLPUTT_DARK_ACTOR_LAST_ATTACK = 285
    case BFI_BUFF_SOYUL = 208
    case BFI_DEBUFF_CHARGED_BOLT_BLOOD_WOUND_MEMO = 331
    case BFI_BUFF_HERO_OF_ELIOS_LEVEL_2 = 108
    case BFI_DEBUFF_ARMOR_CRASH = 250
    case BFI_DEBUFF_SIDE_EFFECT_MEDICINE = 67
    case BFI_BUFF_SWORD_ENCHANT_CHARGE_MP = 337
    case BFI_DEBUFF_EMP_SHOCK_NEAR = 348
    case BFI_BUFF_PROTECTION_OF_LAHEL = 92
    case BFI_BUFF_SI_SA_CTT_TACTICAL_FIELD = 89
    case BFI_RIDING_SCORPION_ENERGY_SWORD = 206
    case BFI_BUFF_PET_AURA_SKILL_LEVEL_1_70 = 126
    case BFI_BUFF_2013_CHRISTMAS = 350
    case BFI_BUFF_PET_AURA_SKILL_LEVEL_3_90 = 138
    case BFI_DEBUFF_SWORD_ENCHANT_FIRE = 166
    case BFI_BUFF_PET_AURA_SKILL_LEVEL_2_90 = 133
    case BFI_BUFF_INDUCTION_PLACE = 86
    case BFI_BUFF_PET_AURA_SKILL_LEVEL_1_80 = 127
    case BFI_BUFF_BRAVE_CREST = 61
    case BFI_BUFF_STRENGTHENING_BODY = 98
    case BFI_DEBUFF_ANCIENT_FIRE_PVP = 305
    case BFI_DEBUFF_SI_SA_AVP_PHANTOM_BREATHING = 121
    case BFI_BUFF_LIMITED_MANA_MANAGEMENT = 161
    case BFI_DEBUFF_SI_A_RST_CUT_TENDON_MEMO = 116
    case BFI_BUFF_INDURANCE_OF_REVENGE = 229
    case BFI_BUFF_PROTECTION_OF_PTAH = 91
    case BFI_BUFF_SET_OPTION_ADD_ENCHANT_RATE_SMALL = 274
    case BFI_BUFF_PET_AURA_SKILL_LEVEL_3_70 = 136
    case BFI_SI_P_ENS_ENERGY_OF_CONCENTRATION = 17
    case BFI_BUFF_RALLY_OF_HERO_LEVEL_1 = 99
    case BFI_BUFF_FIRE_BLOSSOMS = 295
    case BFI_BUFF_PET_AURA_SKILL_LEVEL_2_70 = 131
    case BFI_BUFF_PYLON = 354
    case BFI_BUFF_ELIXIR_SPIRIT_OF_CHASER = 188
    case BFI_DEBUFF_WOUND_BLOODY_WEAPON = 32
    case BFI_BUFF_PET_AURA_SKILL_LEVEL_3_80 = 137
    case BFI_DEBUFF_BORN_TO_BLOOD = 261
    case BFI_SI_SA_ABM_MAGICAL_MAKEUP = 33
    case BFI_SI_P_AEM_ENERGY_OF_THE_PLENTY_3 = 16
}
