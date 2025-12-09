//
//  MatchListViewModel.swift
//  FindReserve
//
//  Created by a on 11/6/25.
//

import Combine
import SwiftData
import Foundation

class MatchListViewModel: ObservableObject {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @Published var rideHistory: [RideHistory] = []
    
    @MainActor init() {
        self.modelContainer = try! ModelContainer(
            for: RideHistory.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: false)
        )
        self.modelContext = modelContainer.mainContext
        self.fetchRideHistory()
    }
    
    func fetchRideHistory() {
        do {
           rideHistory = try modelContext.fetch(FetchDescriptor<RideHistory>())
        } catch {
            print(error.localizedDescription)
        }
    }
}
