//
//  RequestPaymentViewModel.swift
//  FindReserve
//
//  Created by a on 11/6/25.
//

import Combine
import SwiftData
import Foundation

final class RequestPaymentViewModel: ObservableObject {
    private var modelContext: ModelContext
    
    /// 최종 정산 금액
    private(set) var amount: Int
    /// 결제자 정보
    @Published var payUserInfo: Reserve?
    
    private let connectivityManager = ConnectivityManager.shared
    
    private var cancellables = Set<AnyCancellable>()
    /// 결제정보 임시 저장용
    private var rideHistory: RideHistory?
    
    init (amount: Int, modelContext: ModelContext) {
        self.amount = amount
        self.payUserInfo = connectivityManager.hostUser
        self.modelContext = modelContext
        saveRideHistory()
    }
    
    private func fetchMyTrainingInfo() -> TrainingInfo? {
        do {
            let trainingList = try modelContext.fetch(FetchDescriptor<TrainingInfo>())
            return trainingList.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// 탑승기록 임시 저장
    func saveRideHistory() {
        do {
            guard let myTraningInfo = fetchMyTrainingInfo() else { return }
            self.rideHistory = RideHistory(
                departure: myTraningInfo.departure,
                destination: myTraningInfo.destination,
                isPaymentCompleted: false,
                payUserInfo: payUserInfo
            )
            if let rideHistory {
                modelContext.insert(rideHistory)
            }
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    /// 결제 완료 처리
    func completePayment() {
        do {
            let myTraningList = try modelContext.fetch(FetchDescriptor<RideHistory>())
            if let currentTrainingInfo = myTraningList.first(where: { $0.id == rideHistory?.id }) {
                currentTrainingInfo.isPaymentCompleted = true
            }
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
}
