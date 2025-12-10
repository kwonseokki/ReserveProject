//
//  RequestPaymentView.swift
//  FindReserve
//
//  Created by a on 11/6/25.
//

import SwiftUI

import SwiftUI

struct RequestPaymentView: View {
    @StateObject var viewModel: RequestPaymentViewModel
    @EnvironmentObject var router: Router
    @State private var isShowCopyAccountToast = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 8) {
                Text("정산 요청")
                    .font(.title)
                    .fontWeight(.bold)
                Text("아래 정보를 확인하고 정산을 진행해주세요")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            // 금액
            Text("\(viewModel.amount)원")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.blue)
            
            // 결제자 정보
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        if let payUserInfo = viewModel.payUserInfo {
                            Text("결제자: \(payUserInfo.name)")
                            Text("핸드폰 번호: \(payUserInfo.phone)")
                            Text("계좌번호: \(payUserInfo.account)")
                        }
                    }
                    Spacer()
                    Button(action: {
                        UIPasteboard.general.string = viewModel.payUserInfo?.account
                        isShowCopyAccountToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isShowCopyAccountToast = false
                        }
                    }) {
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            CustomButton(text: "정산 완료") {
                viewModel.completePayment()
                router.dismissTrigger = true
            }
                .padding(.horizontal, 20)
                .padding(.bottom, 50)
        }
        .navigationBarBackButtonHidden(true)
        .overlay(
            // 계좌복사 완료 토스트
            Group {
                if isShowCopyAccountToast {
                    Text("계좌번호 복사 완료")
                        .font(.caption)
                        .padding(10)
                        .background(Color.black.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .transition(.opacity)
                        .animation(.easeInOut, value: isShowCopyAccountToast)
                        .padding(.bottom, 150)
                }
            },
            alignment: .bottom
        )
    }
}
