//
//  RideDetailViewModel.swift
//  FindReserve
//
//  Created by a on 12/10/25.
//

import Foundation
import Combine
import SwiftData

final class RideDetailViewModel: ObservableObject {
    private var modelContext: ModelContext
    @Published var rideHistory: RideHistory?
    
    init(modelContext: ModelContext, id: UUID) {
        self.modelContext = modelContext
        do {
            let myTraningList = try modelContext.fetch(FetchDescriptor<RideHistory>())
            rideHistory = myTraningList.first(where: { $0.id == id })
        } catch {
            rideHistory = nil
        }
    }
    
    func completePayment() {
        do {
            let myTraningList = try modelContext.fetch(FetchDescriptor<RideHistory>())
            if let currentTrainingInfo = myTraningList.first(where: { $0.id == rideHistory?.id }) {
                currentTrainingInfo.isPaymentCompleted = true
            }
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
