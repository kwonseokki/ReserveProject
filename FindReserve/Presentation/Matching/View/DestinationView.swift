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
            ZStack(alignment: .bottom) {
                MapView(currentLocation: $viewModel.currentLocation)                    
                    .overlay {
                        if viewModel.isShowSearchBar {
                            searchResult
                        }
                    }
                
                CustomButton(text: "설정 완료") {
                    router.push(.mathcing)
                }
                .opacity(viewModel.isShowSearchBar ? 0 : 1)
                .animation(nil)
                .padding()
            }
            .onChange(of: viewModel.searchText) { searchText in
                viewModel.seachLocation(searchText)
            }
            .searchable(text: $viewModel.searchText, isPresented: $viewModel.isShowSearchBar, prompt: "도착지를 검색해 주세요.(서울)")
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
            .onChange(of: router.dismissTrigger) { _ in
                dismiss()
            }
        }
    }
}

extension DestinationView {
    private var searchResult: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.searchTextResult, id: \.fclt_id) { result in
                    Button {
                        viewModel.selectLocation(.init(latitude: result.lat, longitude: result.lot))
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(result.fclt_nm)
                                Text(result.rdn_addr)
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                        }
                    }
                }
                .padding()
            }
        }
        .background(.white)
    }
}

#Preview {
    DestinationView()
}
