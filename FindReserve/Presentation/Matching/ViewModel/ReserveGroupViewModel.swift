//
//  ReserveGroupViewModel.swift
//  FindReserve
//
//  Created by a on 11/6/25.
//

import Combine
import Foundation

class ReserveGroupViewModel: ObservableObject {
    /// 연결된 유저 정보
    @Published var reserves: [Reserve] = []
    /// 세션 완료 여부
    @Published var paymentRequestCompleted = false
    /// 입력된 정산 금액
    @Published var amount = 0
    /// 정산금액 입력 sheet 표시 여부
    @Published var paymentSheetPresented = false
    
    private let connectivityManager = ConnectivityManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    /// 호스트 여부
    var isHost: Bool { connectivityManager.isHost ?? false }
    /// 정산 금액
    var totalAmount: Int { amount / (connectivityManager.connectedDeviceCount + 1) }
    
    init() {
        connectivityManager.$connectedUsers
            .assign(to: \.reserves, on: self)
            .store(in: &cancellables)
        
        connectivityManager.requestPaymentSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { amount in
                self.amount = amount
                self.paymentRequestCompleted = true
            })
            .store(in: &cancellables)
    }
    
    func requestPayment() {
        do {
            let data = try JSONEncoder().encode(totalAmount)
            try connectivityManager.sendData(data)
            paymentRequestCompleted = true
        } catch {
            
        }
    }
    
    func presentPayemntSheet() {
        paymentSheetPresented = true
    }
    
    func dismissPayementSheet() {
        paymentSheetPresented = false
    }
}
