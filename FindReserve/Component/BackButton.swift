//
//  BackButton.swift
//  FindReserve
//
//  Created by a on 12/10/25.
//

import SwiftUI

struct BackButton: View {
    var description: String?
    let action: ()->()
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: "arrow.backward")
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)
                Text(description ?? "")
                    .foregroundStyle(.black)
            }
        }

    }
}
