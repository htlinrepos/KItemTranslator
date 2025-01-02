//
//  File.swift
//  KItemDeserializer
//
//  Created by Erwin Lin on 1/1/25.
//

import Foundation

enum ITEM_TYPE: Int {
    case IT_NONE = 0          // 에러
    case IT_WEAPON            // 무기
    case IT_DEFENCE           // 방어구
    case IT_ACCESSORY         // 액세서리
    case IT_SKILL             // 스킬
    case IT_QICK_SLOT         // 퀵슬롯 아이템(소비성)
    case IT_MATERIAL          // 재료
    case IT_SPECIAL           // 특수
    case IT_QUEST             // 퀘스트
    case IT_OUTLAY            // 순간소비성
    case IT_ETC               // 기타
    case IT_SKILL_MEMO        // 스킬메모
    case IT_PET               // 펫 (ifdef SERV_UPGRADE_TRADE_SYSTEM)
    case IT_RIDING            // 탈것 (ifdef SERV_UPGRADE_TRADE_SYSTEM)
    case IT_NUM
}

enum ITEM_GRADE: Int {
    case IG_NONE = 0
    case IG_UNIQUE
    case IG_ELITE
    case IG_RARE
    case IG_NORMAL
    case IG_LOW
    case IG_NUM
}

enum PERIOD_TYPE: Int {
    case PT_INFINITY = 0      // 무제한
    case PT_ENDURANCE         // 내구도
    case PT_QUANTITY          // 수량성
    case PT_NUM
}

enum SHOP_PRICE_TYPE: Int {
    case SPT_NONE = 0         // 팔기 불능
    case SPT_CASH             // 캐쉬
    case SPT_GP               // GP
    case SPT_NUM
}

enum USE_CONDITION: Int {
    case UC_NONE = 0          // 아무도 사용할 수 없음
    case UC_ANYONE            // 아무나 사용할 수 있음
    case UC_ONE_UNIT          // 지정된 unit_type 만
    case UC_ONE_CLASS         // 지정된 unit_class 만
    case UC_NUM
}

enum USE_TYPE: Int {
    case UT_NONE = 0          // 장착하는 장비가 아님.
    case UT_SKIN              // 장착하는 장비, 스킨 애니메이션
    case UT_ATTACH_ANIM       // 장착하는 장비, 어태치 애니메이션
    case UT_ATTACH_NORMAL     // 장착하는 장비, 어태치 메시
    case UT_NUM
}

enum SPECIAL_ABILITY_TYPE: Int {
    case SAT_NONE = 0                     // 없음
    case SAT_HP_UP                        // HP 증가
    case SAT_MP_UP                        // MP 증가
    case SAT_REMOVE_CURSE                 // 저주제거
    case SAT_REMOVE_SLOW                  // 슬로우제거
    case SAT_REMOVE_FIRE                  // 화염제거
    case SAT_REMOVE_POISON                // 독제거
    case SAT_RECIPE                       // 레시피 아이템
    case SAT_SUPPLEMENT_ITEM              // 보충제 아이템
    case SAT_HYPER_MODE                   // 각성
    case SAT_SOUL_GAGE_UP                 // 각성게이지 상승
    case SAT_SHOW_OPPONENT_MP             // 상대팀 MP 보기
    case SAT_UP_MP_AT_ATTACK_OR_DAMAGE    // 때리거나 맞을때 MP 상승
    case SAT_HP_PERCENT_UP                // HP 퍼센트 증가
    case SAT_TEAM_HP_UP                   // 팀원들 전부 HP % 증가
    case SAT_TEAM_MP_UP                   // 팀원들 전부 MP % 증가
    case SAT_PEPPER_RUN                   // 고추먹고 맴맴
    case SAT_TRANSFORM_UNIT_SCALE         // 유닛 스케일 조정
    case SAT_SPECIAL_SKILL                // 소비성 아이템을 사용함에 의한 특수 기술
    case SAT_MP_PERCENT_UP                // MP 퍼센트 증가

    case SAT_POWER_RATE_UP                // 공격력 증가 (%)
    case SAT_MOVE_SPEED_UP                // 이동 속도 증가 (%)
    case SAT_JUMP_SPEED_UP                // 점프 속도 증가 (%)
    case SAT_MP_REGENERATION              // 초당 mp 회복
    case SAT_USE_HYPER                    // 각성구슬 없이 강제 각성
    case SAT_PHYSIC_ATTACK_UP             // 물리 공격력 증가 (%)
    case SAT_MAGIC_ATTACK_UP              // 마법 공격력 증가 (%)
    case SAT_PHYSIC_DEFENCE_UP            // 물리 방어력 증가 (%)
    case SAT_MAGIC_DEFENCE_UP             // 마법 방어력 증가 (%)
    case SAT_SUPERARMOR                   // 슈퍼아머
    case SAT_SUMMON_SPIRIT                // 정령소환

    case SAT_REMOVE_FROZEN                // 냉기제거
    case SAT_TRANSFORM_MONSTER            // 몬스터 변신
    case SAT_WAY_OF_SWORD_GAUGE_UP        // 검의길 게이지 증가

    case SAT_SUMMON_MONSTER               // 몬스터 소환 기능

    case SAT_FORCE_CRITICAL_MAX           // 다음 타격 크리 100%
    case SAT_ENABLE_ATTACK_MONSTER        // 해외 할로윈 이벤트

    case SAT_ARA_FORCE_POWER_PERCENT_UP   // 해외 아라 기력 증가 (%)

    case SAT_RETURN_TO_BASE_AT_PVE        // PVE 귀환석

    case SAT_RIDINGPET_STAMINA_PERCENT_UP // 해외 라이딩펫 스테미너 증가 (%)

    case SAT_END
}

enum SPECIAL_ITEM_TYPE: Int {
    case SIT_NONE = 0                    // 없음
    case SIT_NOSTRUM                     // 비약
    case SIT_GENIUS                      // 정령소환
    case SIT_CREST                       // 문장
    case SIT_SUMMON_MONSTER              // 몬스터 소환: 실패없음
    case SIT_END
}

enum ESlashTraceType: Int {
    case STT_SLASH_TRACE = 0
    case STT_SLASH_TRACE_TIP = 1
    case STT_HYPER_SLASH_TRACE = 2
    case STT_HYPER_SLASH_TRACE_TIP = 3
    case STT_END
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
