//
//  ReserveGroupView.swift
//  FindReserve
//
//  Created by a on 11/6/25.
//

import SwiftUI

struct ReserveGroupView: View {
    @StateObject var viewModel: ReserveGroupViewModel
    @EnvironmentObject var router: MatchingRouter
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("OO 훈련장에서 귀가중")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.leading, 20)
            
            Text("총 \(viewModel.reserves.count)명 매칭됨")
                .foregroundColor(.gray)
                .padding(.leading, 20)          
            
            List(viewModel.reserves) { reserve in
                ReserveCell(reserve: reserve)
            }
            
            if viewModel.isHost {
                CustomButton(text: "결제 요청") {
                    viewModel.requestPayment()
                }
                .padding(.horizontal, 20)
            }
        }
        .onChange(of: viewModel.sessionCompleted) { sessionCompleted in
            if sessionCompleted {
                router.push(.requestPayment(amount: viewModel.amount))
            }
        }
        .navigationBarBackButtonHidden(true)       
    }
}

