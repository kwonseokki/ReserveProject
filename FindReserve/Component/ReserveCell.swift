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
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(reserve.name)
                        .fontWeight(.semibold)
                    if reserve.id == hostUser?.id {
                        Text("결제자")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Color.green)
                            .cornerRadius(6)
                    }
                }
                Text(reserve.phone)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(8)
    }
}
