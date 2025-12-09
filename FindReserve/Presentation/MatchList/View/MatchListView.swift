//
//  MatchListView.swift
//  FindReserve
//
//  Created by a on 11/5/25.
//

import SwiftUI

struct MatchListView: View {
    @StateObject var viewModel = MatchListViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.rideHistory) { item in
               RideHistoryCell(rideHistory: item)
            }
            .navigationTitle("내 정산 내역")
        }
    }
}
