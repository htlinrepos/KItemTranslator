//
//  File.swift
//  KItemDeserializer
//
//  Created by Erwin Lin on 1/4/25.
//

import Foundation

enum USE_CONDITION: UInt32, Encodable {
    case UC_NONE = 0        // 아무도 사용할 수 없음
    case UC_ANYONE          // 아무나 사용할 수 있음
    case UC_ONE_UNIT        // 지정된 unit_type 만
    case UC_ONE_CLASS       // 지정된 unit_class 만
}

enum USE_TYPE: UInt32, Encodable {
    case UT_NONE = 0        // 장착하는 장비가 아님.
    case UT_SKIN            // 장착하는 장비, 스킨 애니메이션
    case UT_ATTACH_ANIM     // 장착하는 장비, 어태치 애니메이션
    case UT_ATTACH_NORMAL   // 장착하는 장비, 어태치 메시
}

enum UNIT_TYPE: UInt8, Encodable {
    case UT_NONE = 0
    case UT_ELSWORD
    case UT_ARME
    case UT_LIRE
    case UT_RAVEN
    case UT_EVE
    case UT_CHUNG       // 2010-12-23 에 추가될 신캐릭터 청
    case UT_ARA         // JHKang / 신 캐릭터 아라
    case UT_ELESIS
    case UT_ADD
    case UT_END         // 엘리시스가 추가되면 END를 엘리시스 아래로..
}

enum UNIT_CLASS: UInt8, Encodable {
    // 초기직업
    case UC_NONE = 0
    case UC_ELSWORD_SWORDMAN
    case UC_ARME_VIOLET_MAGE
    case UC_LIRE_ELVEN_RANGER
    case UC_RAVEN_FIGHTER
    case UC_EVE_NASOD
    case UC_CHUNG_IRON_CANNON
    case UC_ARA_MARTIAL_ARTIST          // 7 아라 노전직, 무술가
    case UC_ELESIS_KNIGHT = 8
    case UC_ADD_NASOD_RULER = 9

    // 일차전직
    case UC_ELSWORD_KNIGHT = 10
    case UC_ELSWORD_MAGIC_KNIGHT
    case UC_LIRE_COMBAT_RANGER
    case UC_LIRE_SNIPING_RANGER
    case UC_ARME_HIGH_MAGICIAN
    case UC_ARME_DARK_MAGICIAN
    case UC_RAVEN_SOUL_TAKER
    case UC_RAVEN_OVER_TAKER
    case UC_EVE_EXOTIC_GEAR
    case UC_EVE_ARCHITECTURE
    case UC_CHUNG_FURY_GUARDIAN         // 20 청 1차 전직
    case UC_CHUNG_SHOOTING_GUARDIAN     // 21 청 1차 전직

    case UC_ELSWORD_SHEATH_KNIGHT       // 22
    case UC_ARME_BATTLE_MAGICIAN        // 23
    case UC_LIRE_TRAPPING_RANGER = 24   // 24 레나 트래핑 레인저
    case UC_RAVEN_WEAPON_TAKER = 25
    case UC_EVE_ELECTRA = 26
    case UC_CHUNG_SHELLING_GUARDIAN = 27
    case UC_ARA_LITTLE_HSIEN = 28       // 소선 - 아라 1차 전직

    case UC_ELESIS_SABER_KNIGHT = 29    // 엘리시스 1-1차 세이버 나이트
    case UC_ELESIS_PYRO_KNIGHT = 30     // 엘리시스 1-2차 파이로 나이트

    case UC_ARA_LITTLE_DEVIL = 31       // 소마 - 아라 1차 전직

    case UC_ADD_PSYCHIC_TRACER = 32     // 사이킥 트레이서 - 애드 1차 전직

    // 2차 전직
    case UC_ELSWORD_LORD_KNIGHT = 100
    case UC_ELSWORD_RUNE_SLAYER         // 101
    case UC_LIRE_WIND_SNEAKER           // 102
    case UC_LIRE_GRAND_ARCHER           // 103
    case UC_ARME_ELEMENTAL_MASTER       // 104
    case UC_ARME_VOID_PRINCESS          // 105
    case UC_RAVEN_BLADE_MASTER          // 106
    case UC_RAVEN_RECKLESS_FIST         // 107
    case UC_EVE_CODE_NEMESIS            // 108
    case UC_EVE_CODE_EMPRESS            // 109
    case UC_CHUNG_IRON_PALADIN          // 110
    case UC_CHUNG_DEADLY_CHASER         // 111

    case UC_ELSWORD_INFINITY_SWORD      // 112
    case UC_ARME_DIMENSION_WITCH        // 113
    case UC_LIRE_NIGHT_WATCHER          // 114
    case UC_RAVEN_VETERAN_COMMANDER     // 115
    case UC_EVE_BATTLE_SERAPH           // 116
    case UC_CHUNG_TACTICAL_TROOPER      // 117
    case UC_ARA_SAKRA_DEVANAM = 118     // 제천 - 아라 2차 전직
    case UC_ARA_YAMA_RAJA = 119         // 명왕 - 아라 2차 전직

    case UC_ELESIS_GRAND_MASTER = 120   // 김종훈 // 2013-09-04 // 엘리시스 1-2 그랜드 마스터
    case UC_ELESIS_BLAZING_HEART = 121  // 김종훈 // 2013-09-04 // 엘리시스 2-2 블레이징 하트

    case UC_ADD_LUNATIC_PSYKER = 122    // 루나틱 사이커 - 애드 2차 전직
}

enum PVP_RANK: UInt8, Encodable {
    case PVPRANK_NONE = 0
    case PVPRANK_RANK_ARRANGE
    case PVPRANK_RANK_E
    case PVPRANK_RANK_D
    case PVPRANK_RANK_C
    case PVPRANK_RANK_B
    case PVPRANK_RANK_A
    case PVPRANK_RANK_S
    case PVPRANK_RANK_SS
    case PVPRANK_RANK_SSS

    case PVPRANK_END
}

enum ITEM_TYPE: UInt32, Encodable {
    case IT_NONE = 0    // 에러
    case IT_WEAPON      // 무기
    case IT_DEFENCE     // 방어구
    case IT_ACCESSORY   // 액세서리
    case IT_SKILL       // 스킬
    case IT_QICK_SLOT   // 퀵슬롯 아이템(소비성)
    case IT_MATERIAL    // 재료
    case IT_SPECIAL     // 특수
    case IT_QUEST       // 퀘스트
    case IT_OUTLAY      // 순간소비성
    case IT_ETC         // 기타

    case IT_SKILL_MEMO  // 기술의노트

    case IT_PET         // 펫
    case IT_RIDING      // 탈것
}

enum ITEM_GRADE: UInt32, Encodable {
    case IG_NONE = 0
    case IG_UNIQUE
    case IG_ELITE
    case IG_RARE
    case IG_NORMAL
    case IG_LOW
}

enum PERIOD_TYPE: UInt32, Encodable {
    case PT_INFINITY = 0    // 무제한
    case PT_ENDURANCE       // 내구도
    case PT_QUANTITY        // 수량성
}

enum SHOP_PRICE_TYPE: UInt32, Encodable {
    case SPT_NONE = 0   // 팔기 불능
    case SPT_CASH       // 캐쉬
    case SPT_GP         // GP
}

enum EQIP_POSITION: UInt8, Encodable {
    case EP_NONE = 0
    case EP_QUICK_SLOT      // 퀵슬롯 아이템

    // 무기
    case EP_WEAPON_HAND     // 무기
    case EP_WEAPON_TEMP1    // 임시1
    case EP_WEAPON_TEMP2    // 임시2
    case EP_WEAPON_TEMP3    // 임시3

    // 방어구
    case EP_DEFENCE_HAIR    // 헤어스타일
    case EP_DEFENCE_FACE    // 얼굴
    case EP_DEFENCE_BODY    // 상의
    case EP_DEFENCE_LEG     // 하의
    case EP_DEFENCE_HAND    // 장갑
    case EP_DEFENCE_FOOT    // 신발
    case EP_DEFENCE_TEMP1   // 임시1
    case EP_DEFENCE_TEMP2   // 임시2
    case EP_DEFENCE_TEMP3   // 임시3

    // 액세서리
    case EP_AC_TITLE        // 칭호
    case EP_AC_HAIR         // 헤어
    case EP_AC_FACE1        // 얼굴(상)
    case EP_AC_FACE2        // 얼굴(중)
    case EP_AC_FACE3        // 얼굴(하)
    case EP_AC_BODY         // 상의
    case EP_AC_LEG          // 다리
    case EP_AC_ARM          // 팔
    case EP_AC_RING         // 반지
    case EP_AC_NECKLESS     // 목걸이
    case EP_AC_WEAPON       // 무기 악세사리
    case EP_AC_TEMP2        // 임시2
    case EP_AC_TEMP3        // 임시3
    case EP_AC_TEMP4        // 임시4
    case EP_AC_TEMP5        // 임시5

    // 필살기
    case EP_SKILL_1         // 1단계 필살기
    case EP_SKILL_2         // 2단계 필살기
    case EP_SKILL_3         // 3단계 필살기
    case EP_SKILL_TEMP1     // 임시1
    case EP_SKILL_TEMP2     // 임시2
    case EP_SKILL_TEMP3     // 임시3

    case EP_RAVEN_LEFT_ARM      // dmlee 2008.07.31 - 레이븐 왼팔, 오른팔 나누면서
    case EP_WEAPON_SECOND

    case EP_ONEPIECE_FASHION    // 원피스 아바타

    case EP_END
}

struct Stat: Encodable, Equatable {
    static let `default` = Stat()
    
    let m_fBaseHP: Float

    // 공격
    let m_fAtkPhysic: Float
    let m_fAtkMagic: Float

    // 방어
    let m_fDefPhysic: Float
    let m_fDefMagic: Float
    
    init(m_fBaseHP: Float = 0.0,
         m_fAtkPhysic: Float = 0.0,
         m_fAtkMagic: Float = 0.0,
         m_fDefPhysic: Float = 0.0,
         m_fDefMagic: Float = 0.0) {
        self.m_fBaseHP = m_fBaseHP
        self.m_fAtkPhysic = m_fAtkPhysic
        self.m_fAtkMagic = m_fAtkMagic
        self.m_fDefPhysic = m_fDefPhysic
        self.m_fDefMagic = m_fDefMagic
    }
    
    init(format: KItemFormatStatData) {
        m_fBaseHP = format.m_fBaseHP
        m_fAtkPhysic = format.m_fAtkPhysic
        m_fAtkMagic = format.m_fAtkMagic
        m_fDefPhysic = format.m_fDefPhysic
        m_fDefMagic = format.m_fDefMagic
    }
}

struct SpecialAbility: Encodable, Equatable {
    static let `default` = SpecialAbility()
    
    let m_Type: SPECIAL_ABILITY_TYPE
    let m_CoolTime: Int
    let m_Value1: Int
    let m_Value2: Int
    let m_Value3: Int
    
    enum CodingKeys: String, CodingKey {
        case m_Type = "TYPE"
        case m_CoolTime = "COOL_TIME"
        case m_Value1 = "VALUE1"
        case m_Value2 = "VALUE2"
        case m_Value3 = "VALUE3"
    }
    
    init(m_Type: SPECIAL_ABILITY_TYPE = .SAT_NONE,
         m_CoolTime: Int = 0,
         m_Value1: Int = 0,
         m_Value2: Int = 0,
         m_Value3: Int = 0) {
        self.m_Type = m_Type
        self.m_CoolTime = m_CoolTime
        self.m_Value1 = m_Value1
        self.m_Value2 = m_Value2
        self.m_Value3 = m_Value3
    }
    
    init(format: KItemFormatSpecialAbility) {
        m_Type = .init(rawValue: format.m_dwType)!
        m_CoolTime = format.m_CoolTime.toInt()
        m_Value1 = format.m_Value1.toInt()
        m_Value2 = format.m_Value2.toInt()
        m_Value3 = format.m_Value3.toInt()
    }
}

enum SPECIAL_ABILITY_TYPE: UInt32, Encodable {
    case SAT_NONE = 0       // 없음
    case SAT_HP_UP          // HP증가
    case SAT_MP_UP          // MP증가
    case SAT_REMOVE_CURSE   // 저주제거
    case SAT_REMOVE_SLOW    // 슬로우제거
    case SAT_REMOVE_FIRE    // 화염제거
    case SAT_REMOVE_POISON  // 독제거
    case SAT_RECIPE         // 레시피 아이템
    case SAT_SUPPLEMENT_ITEM    // 보충제 아이템
    case SAT_HYPER_MODE         // 각성
    case SAT_SOUL_GAGE_UP       // 각성게이지 상승
    case SAT_SHOW_OPPONENT_MP   // 상대팀 MP 보기
    case SAT_UP_MP_AT_ATTACK_OR_DAMAGE  // 때리거나 맞을때 MP 상승
    case SAT_HP_PERCENT_UP          // HP 퍼센트 증가
    case SAT_TEAM_HP_UP             // 팀원들 전부 HP % 증가
    case SAT_TEAM_MP_UP             // 팀원들 전부 MP % 증가
    case SAT_PEPPER_RUN             // 고추먹고 맴맴
    case SAT_TRANSFORM_UNIT_SCALE   // 유닛 스케일 조정
    case SAT_SPECIAL_SKILL      // 소비성 아이템을 사용함에 의한 특수 기술
    case SAT_MP_PERCENT_UP      // MP 퍼센트 증가
    case SAT_POWER_RATE_UP      // 공격력 증가 (%)
    case SAT_MOVE_SPEED_UP      // 이동 속도 증가 (%)
    case SAT_JUMP_SPEED_UP      // 점프 속도 증가 (%)
    case SAT_MP_REGENERATION    // 초당 mp 회복
    case SAT_USE_HYPER          // 각성구슬 없이 강제 각성
    case SAT_PHYSIC_ATTACK_UP   // 물리 공격력 증가 (%)
    case SAT_MAGIC_ATTACK_UP    // 마법 공격력 증가 (%)
    case SAT_PHYSIC_DEFENCE_UP  // 물리 방어력 증가 (%)
    case SAT_MAGIC_DEFENCE_UP   // 마법 방어력 증가 (%)
    case SAT_SUPERARMOR         // 슈퍼아머
    case SAT_SUMMON_SPIRIT      // 정령소환

    case SAT_REMOVE_FROZEN      // 냉기제거
    case SAT_TRANSFORM_MONSTER  // 몬스터 변신
    case SAT_WAY_OF_SWORD_GAUGE_UP  // 검의길 게이지 증가
    case SAT_SUMMON_MONSTER         // 몬스터 소환 기능
    case SAT_FORCE_CRITICAL_MAX     // 다음 타격 크리 100%
    case SAT_ENABLE_ATTACK_MONSTER  // 해외 할로윈 이벤트
    case SAT_ARA_FORCE_POWER_PERCENT_UP     // 해외 아라 기력 증가 (%)
    case SAT_RETURN_TO_BASE_AT_PVE          // PVE 귀환석
    case SAT_RIDINGPET_STAMINA_PERCENT_UP   // 해외 라이딩펫 스테미너 증가 (%)
    case SAT_END
}

struct SStatRelationLevel: Encodable, Equatable {
    static let `default` = SStatRelationLevel()
    
    let m_byBaseHPRelLV: Int
    let m_byAtkPhysicRelLV: Int
    let m_byAtkMagicRelLV: Int
    let m_byDefPhysicRelLV: Int
    let m_byDefMagicRelLV: Int
    
    init(m_byBaseHPRelLV: Int = 0,
         m_byAtkPhysicRelLV: Int = 0,
         m_byAtkMagicRelLV: Int = 0,
         m_byDefPhysicRelLV: Int = 0,
         m_byDefMagicRelLV: Int = 0) {
        self.m_byBaseHPRelLV = m_byBaseHPRelLV
        self.m_byAtkPhysicRelLV = m_byAtkPhysicRelLV
        self.m_byAtkMagicRelLV = m_byAtkMagicRelLV
        self.m_byDefPhysicRelLV = m_byDefPhysicRelLV
        self.m_byDefMagicRelLV = m_byDefMagicRelLV
    }
    
    init(format: KItemFormatStatRelLVData) {
        m_byBaseHPRelLV = format.m_byBaseHPRelLV.toInt()
        m_byAtkPhysicRelLV = format.m_byAtkPhysicRelLV.toInt()
        m_byAtkMagicRelLV = format.m_byAtkMagicRelLV.toInt()
        m_byDefPhysicRelLV = format.m_byDefPhysicRelLV.toInt()
        m_byDefMagicRelLV = format.m_byDefMagicRelLV.toInt()
    }
}

struct ItemTemplet: Encodable {
    var m_ItemID: Int = -1                  // 아이템 ID
    var m_Name: String = ""                 // 아이템 이름
    var m_Description: String = ""          // 아이템 설명
    var m_DescriptionInShop: String = ""    // 아이템 구매전 상점에서만 보이는 설명

    var m_ModelName: [String] = []              // 하이퍼 모드는 _Hyper 를 붙인다
    var m_TextureChangeXETName: String = ""     // 하이퍼 모드는 _Hyper 를 붙인다
    var m_AniXETName: String = ""               // 하이퍼 모드는 _Hyper 를 붙인다
    var m_AniName: String = ""                  // 하이퍼 모드는 _Hyper 를 붙인다
    var m_ShopImage: String = ""
    var m_DropViewer: String = ""               // 드롭시 사용할 파티클 시스템 이름
    
    var m_ItemType: ITEM_TYPE = .IT_NONE
    var m_ItemGrade: ITEM_GRADE = .IG_NONE      // 아이템 등급
    
    var m_bFashion: Bool = false                // 패션 아이템
    var m_bVested: Bool = false                 // 귀속 아이템(양도불능/판매불능)
    var m_bCanEnchant: Bool = false             // 강화가능 아이템인가
    var m_bCanUseInventory: Bool = false        // 인벤토리에서 사용가능한 아이템인가

    var m_bNoEquip: Bool = false    // 착용할수 없는 장비인가(교환용 장비)
    var m_bIsPcBang: Bool = false   // PC방 전용 아이템
    var m_iItemLevel: Int = 0       // 아이템 레벨 정보

    var m_ucMaxSealCount: Int = 0         // 최대로 봉인할 수 있는 횟수
    var m_iMaxAttribEnchantCount: Int = 0   // 최대 속성 강화 횟수
    
    var m_UseType: USE_TYPE = .UT_NONE              // 사용 방식 장착장비인지 아닌지, 장착장비라면 어떤식으로 장착하는지
    var m_AttachFrameName: [String] = []            // 어느 본에 붙는가
    
    var m_bCanHyperMode: Bool = false               // 하이퍼 모드 가능 아이템인가
    var m_PeriodType: PERIOD_TYPE = .PT_INFINITY    // 아이템 존재기간
    var m_Endurance: Int = -1             // 초기내구도
    var m_EnduranceDamageMin: Int = 0     // 1스테이지플레이당내구도 감소량 최소
    var m_EnduranceDamageMax: Int = 0     // 1스테이지플레이당내구도 감소량 최대
    var m_RepairED: Float = 0.0     // 내구도 1 수리당 ED
    var m_RepairVP: Int = 0         // 내구도 1 수리당 VP
    var m_Quantity: Int = 0         // 1묶음수량
    
    var m_PriceType: SHOP_PRICE_TYPE = .SPT_NONE    // 가격타입
    var m_Price: Int = 0            // 가격
    var m_PricePvPPoint: Int = 0    // 구매대전포인트

    var m_UseCondition: USE_CONDITION = .UC_NONE    // 사용 조건
    var m_UnitType: UNIT_TYPE = .UT_NONE            // 사용 unittype
    var m_UnitClass: UNIT_CLASS = .UC_NONE          // 사용 unit 클래스
    var m_UseLevel: Int = 0                         // 사용 제한 레벨
    
    var m_BuyPvpRankCondition: PVP_RANK = .PVPRANK_NONE // 사용 랭크
    var m_EqipPosition: EQIP_POSITION = .EP_NONE    // 장착 위치
    var m_Stat: Stat = Stat()                       // 아이템 스탯
    var m_SpecialAbilityList: [SpecialAbility] = [] // 특수 능력 목록
    var m_vecSocketOption: [Int] = []               // 소켓 옵션
    var m_vecRandomSocketGroupID: [Int] = []        // 랜덤 소켓 그룹 ID

    var m_kStatRelationLevel: SStatRelationLevel = SStatRelationLevel() // 스탯 관계 레벨

    var m_CoolTime: Int = 0         // 쿨타임
    var m_SetID: Int = 0            // 세트 ID

    var m_iAttributeLevel: Int = 0        // 요구 속성 레벨
    var m_iBuffFactorID: Int = 0            // 버프 팩터 ID
}

struct SetItemData: Encodable {
    var m_SetID: Int = 0        // 세트 ID
    var m_SetName: String = ""  // 세트 이름
    var m_mapNeedPartsNumNOptions: [Int: [Int]] = [:]   // 필요한 파츠 수와 옵션을 매핑한 딕셔너리
    
    enum CodingKeys: String, CodingKey {
        case m_SetID
        case m_SetName
        case m_mapNeedPartsNumNOptions = "m_NeedPartsNum"
    }
}

extension ItemTemplet {
   enum CodingKeys: String, CodingKey {
       case m_ItemID
       case m_Name
       case m_Description
       case m_DescriptionInShop
       case m_ModelName
       case m_TextureChangeXETName
       case m_AniXETName
       case m_AniName
       case m_ShopImage
       case m_DropViewer
       case m_ItemType
       case m_ItemGrade
       case m_bFashion
       case m_bVested
       case m_bCanEnchant
       case m_bCanUseInventory
       case m_bNoEquip
       case m_bIsPcBang = "m_bPcBang"
       case m_iItemLevel = "m_ItemLevel"
       case m_ucMaxSealCount
       case m_iMaxAttribEnchantCount
       case m_UseType
       case m_AttachFrameName
       case m_bCanHyperMode
       case m_PeriodType
       case m_Endurance
       case m_EnduranceDamageMin
       case m_EnduranceDamageMax
       case m_RepairED
       case m_RepairVP
       case m_Quantity
       case m_PriceType
       case m_Price
       case m_PricePvPPoint
       case m_UseCondition
       case m_UnitType
       case m_UnitClass
       case m_UseLevel
       case m_BuyPvpRankCondition
       case m_EqipPosition
       case m_Stat
       case m_SpecialAbilityList
       case m_vecSocketOption = "SOCKET_OPTION"
       case m_vecRandomSocketGroupID = "RANDOM_SOCKET_GROUP_ID"
       case m_kStatRelationLevel = "m_Stat_Relation_Level"
       case m_CoolTime
       case m_SetID
       case m_iAttributeLevel
       case m_iBuffFactorID
   }
}
