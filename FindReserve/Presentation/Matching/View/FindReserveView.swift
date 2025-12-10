//
//  FindReserveView.swift
//  FindReserve
//
//  Created by a on 11/6/25.
//

import SwiftUI

struct FindReserveView: View {
    @StateObject var connectivityManager = ConnectivityManager.shared
    @EnvironmentObject var router: FirstTabRouter
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack {
                if connectivityManager.connectedPeerIDs.count <= 1 {
                    PersonCircle()
                } else if connectivityManager.connectedPeerIDs.count == 2 {
                    HStack {
                        PersonCircle()
                        PersonCircle()
                    }
                } else if connectivityManager.connectedPeerIDs.count == 3 {
                    VStack {
                        PersonCircle()
                        HStack {
                            PersonCircle()
                            PersonCircle()
                        }
                    }
                } else {
                    VStack {
                        PersonCircle()
                        HStack {
                            PersonCircle()
                            PersonCircle()
                        }
                        PersonCircle()
                    }
                }
            }
            .animation(.spring(), value: connectivityManager.connectedPeerIDs.count)
            
            Text("근처의 예비군님을 찾고있어요!")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.top, 10)
            
            if connectivityManager.isConnected {
                Text("\(connectivityManager.connectedPeerIDs.count)명의 예비군님이 모였어요!")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            } else {
                Text("금방 찾아드릴게요! 잠시만 기다려주세요")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            
            Label {
                Text("\(max(connectivityManager.connectedPeerIDs.count, 1))/4")
                    .fontWeight(.bold)
            } icon: {
                Image(systemName: "person")
                    .renderingMode(.template)
                    .foregroundStyle(.main)
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
            )
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: BackButton(description: "지도", action: {
            router.pop()
        })
        )
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

struct PersonCircle: View {
    @State private var pulse = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.main.opacity(0.9), .main.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .main.opacity(0.4), radius: 10, x: 0, y: 4)
                .shadow(color: .main.opacity(0.2), radius: 20)
                        
            Circle()
                .stroke(.main.opacity(0.5), lineWidth: 4)
                .scaleEffect(pulse ? 1.1 : 0.85)
                .opacity(pulse ? 0.4 : 0.15)
                .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true), value: pulse)
                        
            Image(systemName: "person.fill")
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(.white.opacity(0.95))
        }
        .frame(width: 55, height: 55)
        .onAppear {
            pulse = true
        }
    }
}
