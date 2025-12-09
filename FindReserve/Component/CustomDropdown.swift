//
//  CustomDropdown.swift
//  FindReserve
//
//  Created by a on 12/10/25.
//

import SwiftUI

struct CustomDropdown: View {
    let title: String
    @Binding var selection: String
    @Binding var isExpanded: Bool
    let list: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                
            
            Button {
                withAnimation(.spring(duration: 0.25)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text(selection.isEmpty ? "선택하세요" : selection)
                        .foregroundColor(selection.isEmpty ? .gray : .primary)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(.secondarySystemBackground))
                )
            }
            
            if isExpanded {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(list, id: \.self) { item in
                            Button {
                                withAnimation(.spring(duration: 0.25)) {
                                    selection = item
                                    isExpanded = false
                                }
                            } label: {
                                Text(item)
                                    .foregroundColor(.primary)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(.systemBackground))
                            }
                            Divider()
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(.separator))
                    )                    
                }
            }
        }
    }
}
