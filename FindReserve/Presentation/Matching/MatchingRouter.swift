//
//  MatchingRouter.swift
//  FindReserve
//
//  Created by a on 11/6/25.
//

import SwiftUI
import Combine

enum Route {
    case mathcing
    case reserveGroup
    case requestPayment
}

class MatchingRouter: ObservableObject {
    @Published var path: [Route] = []
    @Published var dismissTrigger = false
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        path.popLast()
    }
    
    func popToRoot() {
        path.removeAll()
        dismissTrigger = false
    }
}
