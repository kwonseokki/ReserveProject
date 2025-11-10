//
//  ReserveGroupViewModel.swift
//  FindReserve
//
//  Created by a on 11/6/25.
//

import Combine
import Foundation

class ReserveGroupViewModel: ObservableObject {
    @Published var reserves: [Reserve] = []
    @Published var sessionCompleted = false
    @Published var amount = 0
    
    private let connectivityManager = ConnectivityManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    var connectedPeers: Int {
        connectivityManager.connectedPeerCount
    }
    
    init() {
        bindData()
    }
    
    func bindData() {
        connectivityManager
            .connectedUserSubject
            .sink(receiveValue: { connectedUser in
                self.reserves = connectedUser.map { Reserve(name: $0.name, phone: $0.phoneNumber, isPayer: false)}
            })
            .store(in: &cancellables)
        
        connectivityManager
            .requestPaymentSubject
            .sink { amount in
                self.amount = amount
                self.sessionCompleted = true
            }
            .store(in: &cancellables)
    }
    
    func requestPayment() {
        do {
            let data = try JSONEncoder().encode(10000)
            try connectivityManager.sendData(data)
            sessionCompleted = true
        } catch {
            
        }
    }
}
