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
    private let maxConnectedTime: Int = 30
    private let localPeerID = MCPeerID(displayName: UUID().uuidString)
    private let matchServiceType: String = "Match-service"        
    
    /// 매칭 완료 여부
    @Published var connecteComplete: Bool = false
    /// 연결된 유저 정보
    @Published var connectedUsers: [Reserve] = []
    /// 연결된 유저 ID
    @Published var connectedPeerIDs: [String] = []
    
    /// 다른 디바이스와 연결 여부
    var isConnected: Bool { session.connectedPeers.count > 0 }
    /// 랜덤으로 부여되는 기기 고유 ID
    var localInviterID: String { localPeerID.displayName }
    /// 호스트 여부
    var isHost: Bool { localInviterID == connectedPeerIDs.max() }
    /// 호스트 유저 정보
    var hostUser: Reserve? { connectedUsers.first(where: { $0.id == connectedPeerIDs.max() }) }
    /// 연결된 디바이스 개수
    var connectedDeviceCount : Int { connectedPeerIDs.count }
    
    /// 결제 요청
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
    }
    
    func stopAdvertising() {
        // 매칭 완료시 검색 중지
        timer = nil
        connecteComplete = true
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
    }
    
    // 데이터 전송
    func sendData(_ data: Data) throws {
        try session.send(data, toPeers: session.connectedPeers, with: .reliable)
    }
}

// MARK: - AdvertiserDelegate
extension ConnectivityManager: MCNearbyServiceAdvertiserDelegate {
    // 근처 피에어게 초대 받은 경우
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // 초대를 보낸 피어에게 세션 제공
        invitationHandler(true, session)
    }
}

// MARK: - MCSessionDelegate
extension ConnectivityManager: MCSessionDelegate {
    // 세션 변경시 connectedPeerCount 업데이트
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            print("notConnected")
        case .connecting:
            print("Connecting...")
        case .connected:
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                connectedPeerIDs = session.connectedPeers.map { $0.displayName } + [localPeerID.displayName]
                if connectedPeerIDs.count >= 3 {
                    stopAdvertising()
                }
            }
            
            if let user = KeyChainManager.getUser() {
                let userInfo = Reserve(id: localInviterID, name: user.name, phone: user.phoneNumber, account: user.account)
                if let userData = try? JSONEncoder().encode(userInfo) {
                    try? sendData(userData)
                }
            }
        @unknown default:
            break
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // 유저 정보 동기화
        if let user = try? JSONDecoder().decode(Reserve.self, from: data) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if !connectedUsers.contains(where: { $0.id == user.id }) {
                    connectedUsers.append(user)
                }
            }
        }
        // 정산요청
        if let amount = try? JSONDecoder().decode(Int.self, from: data) {
            requestPaymentSubject.send(amount)
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

// MARK: - BrowserDelegate
extension ConnectivityManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("peerID \(localPeerID)")
        
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print(#function)
    }
}

extension Data {
    func decode<T: Decodable>(_ type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: self)
    }
}

extension Encodable {
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
}
