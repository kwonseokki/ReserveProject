//
//  MatchingView.swift
//  FindReserve
//
//  Created by a on 11/5/25.
//

import SwiftUI

struct MatchingView: View {
    @State var isPresented: Bool = false
    @StateObject var router = MatchingRouter()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("OOO 예비군님 안녕하세요")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("다가오는 훈련 정보")
                    .font(.title2)
                    .bold()
                Text("다가오는 훈련 정보를 놓치지 말고 확인하세요")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 10)
            
            VStack(alignment: .leading, spacing: 8) {
                Label("기본훈련 (2차)", systemImage: "list.bullet.clipboard")
                    .font(.headline)
                Label("2025.11.05(6h)", systemImage: "clock")
                    .font(.subheadline)
                Label("위치: 용인시 운학 과학화 훈련장", systemImage: "mappin.circle")
                    .font(.subheadline)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.1))
            .cornerRadius(12)
            .padding(.top, 15)
            
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Image(systemName: "person.text.rectangle")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                    VStack(alignment: .leading) {
                        Text("훈련 종료까지 20분 남았습니다")
                            .font(.headline)
                        Text("근처 예비군님들과 함께 귀가하세요!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("귀가 매칭")
                        .font(.title2)
                        .bold()
                    Text("근처 예비군님들과 함께 안전하게 귀가하세요 🚕")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 10)
                
                VStack(alignment: .leading) {
                    Text("현재 주변에 예비군이 3명 있습니다.")
                        .font(.subheadline)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<3) { _ in
                                VStack {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.gray)
                                    Text("OOO 예비군님")
                                        .font(.caption)
                                }
                                .padding(8)
                                .background(.gray.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                    }
                }
                VStack {
                    CustomButton(text: "매칭 시작하기") {
                        isPresented = true
                    }
                    Text("버튼을 누르면 목적지에 맞게 귀가 매칭이 시작됩니다.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .fullScreenCover(isPresented: $isPresented, onDismiss: {
            router.popToRoot()
        }, content: {
            DestinationView()
        })
        .environmentObject(router)
    }
}

#Preview {
    MatchingView()
}
