//
//  ReserveCell.swift
//  FindReserve
//
//  Created by a on 11/6/25.
//

import SwiftUI

struct ReserveCell: View {
    let reserve: Reserve
    let hostUser: Reserve?
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: 35, height: 35)
                .foregroundStyle(.main)
                .overlay(
                    Text(String(reserve.name.first ?? "예"))
                        .foregroundStyle(.text)
                        .fontWeight(.semibold)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(reserve.name)
                    .font(.system(size: 14, weight: .semibold))
                    .fontWeight(.semibold)
                Text(reserve.phone)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            if reserve.id == hostUser?.id {
                Label(title: {
                    Text("결제자")
                }, icon: {
                    Image(systemName: "checkmark.circle")
                })
                    .font(.caption)
                    .foregroundColor(.black)
                    .padding(8)
                    .background(Color.main)
                    .cornerRadius(8)
            }
        }
    }
}
