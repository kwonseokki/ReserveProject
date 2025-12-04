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
    @Published var inviterID: String = ""
    
    private let connectivityManager = ConnectivityManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    var isHost: Bool {
        connectivityManager.isHost ?? false
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
