//
//  FindReserveView.swift
//  FindReserve
//
//  Created by a on 11/6/25.
//

import SwiftUI

struct FindReserveView: View {    
    @StateObject var connectivityManager = ConnectivityManager.shared
    @EnvironmentObject var router: MatchingRouter
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text("주변 예비군 탐색 중...")
                .font(.title3)
                .fontWeight(.semibold)
            
            if connectivityManager.isConnected {
                Text("\(connectivityManager.connectedPeerIDs.count)/4 명이 매칭됨")
                    .font(.caption)
            }
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(2)
                .padding(.top, 20)
            
            Text("잠시만 기다려주세요")
                .foregroundColor(.gray)
                .font(.subheadline)
            
            Spacer()
            
            Button(action: {
                connectivityManager.stopSession()
                router.dismissTrigger = true
            }) {
                Text("탐색 취소")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
        .onAppear {
            connectivityManager.startSession()
        }
        .onChange(of: connectivityManager.connecteComplete) { connecteComplete in
            if connecteComplete {
                router.push(.reserveGroup)                
            }
        }
    }
}
