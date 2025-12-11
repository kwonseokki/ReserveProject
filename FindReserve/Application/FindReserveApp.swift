//
//  FindReserveApp.swift
//  FindReserve
//
//  Created by a on 11/5/25.
//

import SwiftUI
import SwiftData

@main
struct FindReserveApp: App {
    private var container = try! ModelContainer(
        for: TrainingInfo.self,
        RideHistory.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: false)
    )
    @StateObject private var router1 = FirstTabRouter()
    @StateObject private var router2 = SecondTabRouter()
    @StateObject private var router3 = ThirdTabRouter()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContext(container.mainContext)
                .environmentObject(router1)
                .environmentObject(router2)
                .environmentObject(router3)
        }
    }
}
