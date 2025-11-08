//
//  Location.swift
//  FindReserve
//
//  Created by a on 11/9/25.
//

struct LocationObject: Decodable {
    let DATA: [Location]
}

struct Location: Decodable {
    let data_crtr_dd: Int
    let fclt_id: String
    let new_addr_id: String
    let rdn_addr: String
    let etc: String
    let bldn_clny_yn: String
    let lotno_addr: String
    let id: String
    let fclt_nm: String
    let fclt_usg_se: String
    let lot: Double
    let ntn_brnch_no: String
    let lat: Double
}
