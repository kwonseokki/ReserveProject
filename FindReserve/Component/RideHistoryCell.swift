//
//  RideHistoryCell.swift
//  FindReserve
//
//  Created by a on 12/9/25.
//

import SwiftUI

struct RideHistoryCell: View {
    let rideHistory: RideHistory
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("\(rideHistory.createdAt)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("\(rideHistory.departure) → \(rideHistory.destination)")
                    .fontWeight(.semibold)
            }
            Spacer()
            Text(rideHistory.isPaymentCompleted ? "정산완료" : "미정산")
                .font(.caption)
                .foregroundColor(.white)
                .padding(6)
                .background(rideHistory.isPaymentCompleted ? Color.green : Color.red)
                .cornerRadius(6)
        }
        .padding(.vertical, 6)
    }
}
