//
//  RequestPaymentViewModel.swift
//  FindReserve
//
//  Created by a on 11/6/25.
//

import Combine

class RequestPaymentViewModel: ObservableObject {
    let amount: Int = 12000
    let payerName: String = "예비군"
    let bank: String = "신한은행"
    let account: String = "123-456-7890"
}
