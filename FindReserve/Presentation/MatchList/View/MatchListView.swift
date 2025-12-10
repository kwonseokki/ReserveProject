//
//  MatchListView.swift
//  FindReserve
//
//  Created by a on 11/5/25.
//

import SwiftUI

struct MatchListView: View {
    @StateObject var viewModel: MatchListViewModel
    @EnvironmentObject var router: SecondTabRouter
    
    var body: some View {
        NavigationStack(path: $router.path) {
            List(viewModel.rideHistory) { item in
                Button {
                    router.push(.rideDetail)
                } label: {
                    RideHistoryCell(rideHistory: item)
                }
            }
            .onAppear {
                viewModel.fetchRideHistory()
            }
            .navigationDestination(for: SecondTabRoute.self) { destination in
                switch destination {
                case .rideDetail:
                    RideDetailView()
                }
            }
        }
    }
}
