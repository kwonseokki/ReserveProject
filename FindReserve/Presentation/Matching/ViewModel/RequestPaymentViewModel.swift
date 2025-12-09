//
//  RequestPaymentViewModel.swift
//  FindReserve
//
//  Created by a on 11/6/25.
//

import Combine

class RequestPaymentViewModel: ObservableObject {
    /// 최종 정산 금액
    private(set) var amount: Int
    /// 결제자 정보
    @Published var payUserInfo: Reserve?
    
    private let connectivityManager = ConnectivityManager.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    init (amount: Int) {
        self.amount = amount
        self.payUserInfo = connectivityManager.hostUser
    }
}
