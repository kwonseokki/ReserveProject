//
//  ReserveGroupView.swift
//  FindReserve
//
//  Created by a on 11/6/25.
//

import SwiftUI

struct ReserveGroupView: View {
    @StateObject var viewModel: ReserveGroupViewModel
    @EnvironmentObject var router: FirstTabRouter
  
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 출발지 & 도착지 정보
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Circle()
                        .frame(width: 15, height: 15)
                        .foregroundStyle(.main)
                    VStack(alignment: .leading) {
                        Text("출발")
                            .foregroundStyle(.gray)
                            .font(.caption)
                        Text(viewModel.myTrainingInfo?.departure ?? "훈련장")
                            .font(.subheadline)
                    }
                    Spacer()
                }
                VStack {
                    Rectangle()
                        .frame(width: 1, height: 25)
                        .foregroundStyle(.gray)
                }
                .frame(width: 15)
                HStack {
                    Circle()
                        .frame(width: 15, height: 15)
                        .foregroundStyle(.button)
                    VStack(alignment: .leading) {
                        Text("도착")
                            .foregroundStyle(.gray)
                            .font(.caption)
                        Text(viewModel.myTrainingInfo?.destination ?? "")
                            .font(.subheadline)
                    }
                    Spacer()
                }
            }
            .background(.white)
            .padding()
            
            // 동승자 리스트
            ScrollView {
                VStack(alignment:. leading) {
                    Label("동승자 (총 \(viewModel.reserves.count)명)", systemImage: "person.2")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                    CardContainerView {
                        VStack {
                            ForEach(viewModel.reserves, id: \.self.id) { reserve in
                                ReserveCell(reserve: reserve, hostUser: viewModel.hostUser)
                            }
                        }
                    }
                }
                .padding()
            }
            .padding(.top, 10)
            .background(.customBackground)
            
            // 정산하기
            if viewModel.isHost {
                VStack {
                    HStack {
                        VStack {
                            Text("결제 금액")
                                .font(.caption)
                                .foregroundStyle(.gray)
                            Text("\(viewModel.amount) 원")
                                .font(.title2)
                                .fontWeight(.bold)                                
                        }
                        Spacer()
                        
                        Button {
                            viewModel.presentPayemntSheet()
                        } label: {
                            Text("정산하기")
                                .fontWeight(.bold)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 14)
                        }
                        .background(.button)
                        .cornerRadius(12)
                    }
                    .padding()
                }
                .background(.white)
            }
        }
      
        .sheet(isPresented: $viewModel.paymentSheetPresented, content: {
            VStack(alignment: .leading) {
                Text("\(viewModel.amount) 원")
                    .font(.title)
                Text("결제를 요청하기 전 신중하게 금액을 입력해주세요.")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                TextField("Enter a number", value: $viewModel.amount, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                
                CustomButton(text: "결제 요청") {
                    viewModel.dismissPayementSheet()
                    viewModel.requestPayment()
                }
            }
            .padding(.horizontal, 16)
            .presentationDetents([.height(200)])
        })
        .onChange(of: viewModel.paymentRequestCompleted) { sessionCompleted in
            if sessionCompleted {
                router.push(.requestPayment(amount: viewModel.amount))
            }
        }
        .navigationBarBackButtonHidden(true)       
    }
}

