//
//  ReserveGroupView.swift
//  FindReserve
//
//  Created by a on 11/6/25.
//

import SwiftUI

struct ReserveGroupView: View {
    @StateObject var viewModel: ReserveGroupViewModel
    @EnvironmentObject var router: Router
  
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(viewModel.myTrainingInfo?.departure ?? "훈련장") 에서 복귀중")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.leading, 20)
            
            Text("총 \(viewModel.reserves.count)명 매칭됨")
                .foregroundColor(.gray)
                .padding(.leading, 20)          
            
            List(viewModel.reserves) { reserve in
                ReserveCell(reserve: reserve, hostUser: viewModel.hostUser)
            }
            
            if viewModel.isHost {
                CustomButton(text: "정산 하기") {
                    viewModel.presentPayemntSheet()
                }
                .padding(.horizontal, 20)
            }
        }
        .sheet(isPresented: $viewModel.paymentSheetPresented, content: {
            VStack {
                Text("\(viewModel.amount) 원")
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

