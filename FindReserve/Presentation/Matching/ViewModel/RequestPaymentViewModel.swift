//
//  RequestPaymentViewModel.swift
//  FindReserve
//
//  Created by a on 11/6/25.
//

import Combine
import SwiftData
import Foundation

class RequestPaymentViewModel: ObservableObject {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    /// 최종 정산 금액
    private(set) var amount: Int
    /// 결제자 정보
    @Published var payUserInfo: Reserve?
    
    private let connectivityManager = ConnectivityManager.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    init (amount: Int) {
        self.amount = amount
        self.payUserInfo = connectivityManager.hostUser
        self.modelContainer = try! ModelContainer(
            for: RideHistory.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: false)
        )
        self.modelContext = modelContainer.mainContext
    }
    
    func saveRideHistory() {
        // 이용내역 저장
        let rideHistory = RideHistory(
            departure: "출발지",
            destination: "도착지",
            isPaymentCompleted: true,
            payUserInfo: payUserInfo
        )
        modelContext.insert(rideHistory)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
