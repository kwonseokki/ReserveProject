//
//  MatchingViewModel.swift
//  FindReserve
//
//  Created by a on 11/11/25.
//

import Foundation
import Combine
import SwiftData

class MatchingViewModel: ObservableObject {
    private var modelContext: ModelContext
    @Published var myTrainingInfo: TrainingInfo?
    @Published var userInfo: User?
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    /// 유저 정보 가져오기
    func getUserInfo() {
        if let user = KeyChainManager.getUser() {
            self.userInfo = User(name: user.name, phoneNumber: user.phoneNumber, account: user.account)
        }
    }
    
    /// 훈련정보 가져오기
    func fetchTrainingInfo() {
        do {
            let trainingList = try modelContext.fetch(FetchDescriptor<TrainingInfo>())
            if let myTrainingInfo = trainingList.first {
                self.myTrainingInfo = myTrainingInfo
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
