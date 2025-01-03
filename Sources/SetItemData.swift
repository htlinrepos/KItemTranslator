//
//  File.swift
//  KItemDeserializer
//
//  Created by Erwin Lin on 1/4/25.
//

import Foundation

struct SetItemData {
    var m_SetID: Int = 0        // 세트 ID
    var m_SetName: String = ""  // 세트 이름
    var m_mapNeedPartsNumNOptions: [Int: [Int]] = [:]   // 필요한 파츠 수와 옵션을 매핑한 딕셔너리
}
