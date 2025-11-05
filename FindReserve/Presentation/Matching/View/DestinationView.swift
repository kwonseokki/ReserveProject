//
//  DestinationView.swift
//  FindReserve
//
//  Created by a on 11/5/25.
//

import SwiftUI
import MapKit

struct DestinationView: View {
    @StateObject var viewModel = DestinationViewModel()
    @EnvironmentObject var router: MatchingRouter
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack {
                HStack {
                    TextField("", text: $viewModel.searchText)
                        .textFieldStyle(.roundedBorder)
                    Button {
                        
                    } label: {
                        Text("검색")
                    }
                }
                .padding(4)
                Map(coordinateRegion: $viewModel.region)
            }
            .overlay(alignment: .bottom) {
                CustomButton(text: "설정 완료") {
                    router.push(.mathcing)
                }
                .padding()
                .navigationDestination(for: Route.self) { destination in
                    switch destination {
                    case .mathcing:
                        FindReserveView()
                    case .reserveGroup:
                        ReserveGroupView(viewModel: ReserveGroupViewModel())
                    case .requestPayment:
                        RequestPaymentView()                    
                    }
                }
            }
            .onChange(of: router.dismissTrigger) { _ in
                dismiss()
            }
        }
    }
}

#Preview {
    DestinationView()
}
