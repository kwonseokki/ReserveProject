//
//  ConnectivityManager.swift
//  FindReserve
//
//  Created by a on 11/10/25.
//

import Combine
import MultipeerConnectivity

class ConnectivityManager: NSObject, ObservableObject {
    static let shared = ConnectivityManager()
    
    private var session: MCSession!
    private var advertiser: MCNearbyServiceAdvertiser!
    private var browser: MCNearbyServiceBrowser!
    private var connectetime: Int = 0
    private var timer: AnyCancellable?
    
    private let minPeerCount = 2
    private let maxPeerCount: Int = 4
    private let maxConnectedTime: Int = 5
    private let localPeerID = MCPeerID(displayName: UIDevice.current.name)
    private let matchServiceType: String = "Match-service"
    
    
    var isConnected: Bool {
        session.connectedPeers.count > 0
    }
    
    @Published var connectedPeerCount = 0
    @Published var connecteComplete: Bool = false
    @Published var sessionID = ""
    @Published var connectedUsers: [User] = []
    
    let connectedUserSubject = CurrentValueSubject<[User], Never>([])
    let requestPaymentSubject = PassthroughSubject<Int, Never>()
    
    override private init() {
        super.init()
        configureSession()
    }
    
    // 세션 구성
    func configureSession() {
        self.advertiser = MCNearbyServiceAdvertiser(
            peer: localPeerID,
            discoveryInfo: nil,
            serviceType: matchServiceType
        )
        advertiser.delegate = self
        
        self.session = MCSession(
            peer: localPeerID,
            securityIdentity: nil,
            encryptionPreference: .none
        )
        
        session.delegate = self
        
        self.browser = MCNearbyServiceBrowser(peer: localPeerID, serviceType: matchServiceType)
        browser.delegate = self
    }
    
    // 세션 중지
    func stopSession() {
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
        session.disconnect()
        timer = nil
    }
    
    // 세션 시작
    func startSession() {
        
        // 근처 피어에게 세션참여 요청
        advertiser.startAdvertisingPeer()
        // 주변 기기 탐색
        browser.startBrowsingForPeers()
        
        timer =  Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                connectetime += 1
                if connectedPeerCount == maxPeerCount || (connectetime > maxConnectedTime && connectedPeerCount >= minPeerCount) {
                    stopAdvertising()
                }
            })
    }
    
    func stopAdvertising() {
        // 매칭 완료시 검색 중지
        timer = nil
        connecteComplete = true
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
        if let user = KeyChainManager.getUser() {
            if let userData = try? JSONEncoder().encode(user) {
                try? sendData(userData)
            }
        }
    }
    
    // 데이터 전송
    func sendData(_ data: Data) throws {
        try session.send(data, toPeers: session.connectedPeers, with: .reliable)
    }
}

extension ConnectivityManager: MCNearbyServiceAdvertiserDelegate {
    // 근처 피에어게 초대 받은 경우
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // 초대를 보낸 피어에게 세션 제공
        invitationHandler(true, session)
        
        // 초대를 받은 세션 중지
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
        print(#function)
    }
}

extension ConnectivityManager: MCSessionDelegate {
    // 세션 변경시 connectedPeerCount 업데이트
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            connectedPeerCount = session.connectedPeers.count + 1
        }
        print(#function)
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let user = try? JSONDecoder().decode(User.self, from: data) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                connectedUserSubject.send(connectedUserSubject.value + [user])
            }
        }
        if let payment = try? JSONDecoder().decode(Int.self, from: data) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                requestPaymentSubject.send(payment)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print(#function)
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print(#function)
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {
        print(#function)
    }
}

extension ConnectivityManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("peerID \(localPeerID)")
        // 근처에 피어 발견시 초대
        
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print(#function)
    }
}
