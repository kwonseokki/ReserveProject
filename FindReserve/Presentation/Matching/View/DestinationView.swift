//
//  DestinationView.swift
//  FindReserve
//
//  Created by a on 11/5/25.
//

import SwiftUI
import MapKit

struct DestinationView: View {
    @StateObject var viewModel: DestinationViewModel
    @EnvironmentObject var router: Router
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack(path: $router.fullScreenPath) {
            ZStack(alignment: .bottom) {
                VStack {
                    MapView(currentLocation: viewModel.currentLocation)
                        .equatable()
                        .overlay {
                            if viewModel.isShowSearchBar {
                                searchResult
                            }
                        }
                }
                
                CustomButton(text: "설정 완료") {
                    router.push(.mathcing)
                }
                .opacity(viewModel.isShowSearchBar ? 0 : 1)
                .animation(nil)
                .padding()
            }
            .searchable(text: $viewModel.searchText, isPresented: $viewModel.isShowSearchBar, prompt: "도착지를 검색해 주세요.(서울)")
            .onChange(of: viewModel.searchText) { searchText in
                viewModel.seachLocation(searchText)
            }
            .onChange(of: router.dismissTrigger) { _ in
                dismiss()
            }
            .navigationDestination(for: Route.self) { destination in
                switch destination {
                case .mathcing:
                    FindReserveView()
                case .reserveGroup:
                    ReserveGroupView(viewModel: ReserveGroupViewModel(modelContext: modelContext))
                case .requestPayment(let amount):
                    RequestPaymentView(viewModel: RequestPaymentViewModel(amount: amount, modelContext: modelContext))
                case .training:
                    TrainingSelectionView(viewModel: TrainingSelectionViewModel(modelContext: modelContext))
                }
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
                        viewModel.updateDestination(result.fclt_nm)
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

