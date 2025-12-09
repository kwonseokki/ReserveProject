//
//  TrainingInfo.swift
//  FindReserve
//
//  Created by a on 12/9/25.
//

import Foundation
import SwiftData

@Model
class TrainingInfo {
    @Attribute(.unique) var id: UUID = UUID()
    var trainingTypeValue: String
    var trainingType: TrainingType {
        get { TrainingType(rawValue: trainingTypeValue)! }
        set { trainingTypeValue = newValue.rawValue }
    }
    var startDate: Date
    var departure: String
    
    init(id: UUID, trainingTypeValue: String, startDate: Date, departure: String) {
        self.id = id
        self.trainingTypeValue = trainingTypeValue
        self.startDate = startDate
        self.departure = departure
    }
}

enum TrainingType: String, CaseIterable {
    // MARK: - 동원훈련
    case mobilization1 = "동원훈련 1차"
    case mobilization2 = "동원훈련 2차"
    case mobilization3 = "동원훈련 3차"
    
    // MARK: - 동원미참(동원Ⅱ형)
    case mobilizationExempt1 = "동원미참훈련 1차"
    case mobilizationExempt2 = "동원미참훈련 2차"
    case mobilizationExempt3 = "동원미참훈련 3차"
    
    // MARK: - 기본훈련
    case basic1 = "기본훈련 1차"
    case basic2 = "기본훈련 2차"
    case basic3 = "기본훈련 3차"
    
    // MARK: - 작계훈련
    case operation1 = "작계훈련 1차"
    case operation2 = "작계훈련 2차"
    case operation3 = "작계훈련 3차"
    
    // MARK: - 기타 선택형
    case national = "전국단위훈련"
    case holiday = "휴일예비군훈련"
    case muster = "소집점검훈련"
    case extra = "예비시간훈련"
}
