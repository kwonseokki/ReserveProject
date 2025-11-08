//
//  DestinationViewModel.swift
//  FindReserve
//
//  Created by a on 11/6/25.
//

import Combine
import SwiftUI
import MapKit

class DestinationViewModel: ObservableObject {
    @Published var currentLocation = CLLocationCoordinate2D(latitude: 37.5661456404755, longitude: 126.9924672359717)
    @Published var searchText: String = ""
    @Published var searchTextResult: [Location] = []
    @Published var isShowSearchBar: Bool = false
    
    private var searchResult: [Location] = []
    
    init() {
        fetchData()
    }
    
    // 서울시 시설물 정보 가져오기
    func fetchData() {
        guard let path = Bundle.main.path(forResource: "seoul-facility-info", ofType: "json") else { return }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let searchResult = try JSONDecoder().decode(LocationObject.self, from: data)
            self.searchResult = searchResult.DATA
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    // 위치 검색
    func seachLocation(_ text: String) {
        searchTextResult = searchResult.filter { $0.rdn_addr.contains(text) || $0.fclt_nm.contains(text) }
    }
    
    // 위치 선택
    func selectLocation(_ location: CLLocationCoordinate2D) {
        currentLocation = location
        isShowSearchBar = false
    }
}
