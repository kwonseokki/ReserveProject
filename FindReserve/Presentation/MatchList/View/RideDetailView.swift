//
//  RideDetailView.swift
//  FindReserve
//
//  Created by a on 12/10/25.
//

import SwiftUI

struct RideDetailView: View {
    @StateObject var viewModel: RideDetailViewModel
    
    var body: some View {
        VStack {
            if let rideHistory = viewModel.rideHistory {
                Text("\(rideHistory.payUserInfo)")
            }
            
            CustomButton(text: "정산 완료") {
                viewModel.completePayment()
            }
        }
    }
}

