//
//  RootView.swift
//  FindReserve
//
//  Created by a on 11/5/25.
//

import SwiftUI

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var router: FirstTabRouter
    
    var body: some View {
        TabView {
            MatchingView(viewModel: MatchingViewModel(modelContext: modelContext))
                .tabItem {
                    Image(systemName: "person.line.dotted.person")
                    Text("매칭")
                }
            
            MatchListView(viewModel: MatchListViewModel(modelContext: modelContext))
                .tabItem {
                    Image(systemName: "list.clipboard")
                    Text("정산 내역")
                }
            
            SettingView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("설정")
                }
        }
    }
}

#Preview {
    RootView()
}
