//
//  MatchingView.swift
//  FindReserve
//
//  Created by a on 11/5/25.
//

import SwiftUI

struct MatchingView: View {
    @State var isPresented: Bool = false
    @EnvironmentObject var router: FirstTabRouter
    @StateObject var viewModel: MatchingViewModel
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack(alignment: .leading, spacing: 16) {
                Text("안녕하세요!")
                    .foregroundStyle(.gray)
                    .padding(.top, 20)
                HStack {
                    Text("\(viewModel.userInfo?.name ?? "환영합니다") 예비군님")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Image(.profile)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.main)
                        .clipShape(Circle())
                }
                
                // 나의 정보
                CardContainerView {
                    VStack(spacing: 20) {
                        if let userInfo = viewModel.userInfo {
                            HStack {
                                Label {
                                    Text("나의 정보")
                                        .fontWeight(.semibold)
                                } icon: {
                                   Text("🪖")
                                }
                                
                                Spacer()
                            }
                            
                            HStack {
                                Text("핸드폰")
                                    .foregroundStyle(.gray)
                                Spacer()
                                Text(userInfo.phoneNumber)
                            }
                            
                            HStack {
                                Text("계좌")
                                    .foregroundStyle(.gray)
                                Spacer()
                                Text(userInfo.account)
                            }
                        } else {
                            Text("유저 정보를 등록해주세요")
                        }
                      
                    }
                }
                
                // 훈련 정보
                CardContainerView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Label {
                                Text("다가오는 훈련")
                                    .fontWeight(.semibold)
                            } icon: {
                                Text("📋")
                            }
                            
                            Spacer()
                        }
                        
                        if let myTrainingInfo = viewModel.myTrainingInfo {
                            HStack(spacing: 8) {
                                Image(.marker)
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.main)
                                VStack(alignment: .leading) {
                                    Text("훈련장소")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                    Text(myTrainingInfo.departure)
                                }
                            }
                            HStack(spacing: 8) {
                                Image(.marker)
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.main)
                                VStack(alignment: .leading) {
                                    Text("훈련 일정")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                    Text(myTrainingInfo.startDate.toYYYYMMDD())
                                }
                            }
                            
                            Text(myTrainingInfo.trainingTypeValue)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(8)
                                .background(.main)
                                .cornerRadius(8)
                        } else {
                            Text("훈련정보를 등록해주세요")
                        }
                    }
                }
                .onTapGesture {
                    router.push(.training)
                }
                
                // 매칭 시작하기
                CustomButton(text: "동승 매칭 시작하기", icon: Image(.car)) {
                    router.presentFullScreen(.mathcing)
                }
                .padding(.top, 10)
                
                Label {
                    Text("버튼을 누르면 목적지에 맞게 귀가 매칭이 시작됩니다.")
                        .font(.caption)
                } icon: {
                    Text("💡")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.gray.opacity(0.1))
                .cornerRadius(12)
                Spacer()
            }
            .onAppear {
                viewModel.fetchTrainingInfo()
                viewModel.getUserInfo()
            }
            .padding(.horizontal, 20)
            .background(.customBackground)
            .fullScreenCover(item: $router.fullScreenCover) { destination in
                DestinationView(viewModel: DestinationViewModel(modelContext: modelContext))
            }
            .navigationDestination(for: FirstTabRoute.self) { destination in
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
