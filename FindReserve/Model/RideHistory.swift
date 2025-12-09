//
//  RideHistory.swift
//  FindReserve
//
//  Created by a on 12/9/25.
//

import Foundation
import SwiftData

@Model
class RideHistory: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()  // 고유 ID
    var departure: String            // 출발지
    var destination: String          // 도착지
    var isPaymentCompleted: Bool     // 결제 완료 여부
    var createdAt: Date              // 생성일
    var payUserInfo: Reserve?
    
    // 필요하면 편의 초기화
    init(
        departure: String,
        destination: String,
        isPaymentCompleted: Bool,
        createdAt: Date = Date(),
        payUserInfo: Reserve? = nil
    ) {
        self.departure = departure
        self.destination = destination
        self.isPaymentCompleted = isPaymentCompleted
        self.createdAt = createdAt
        self.payUserInfo = payUserInfo
    }
}
