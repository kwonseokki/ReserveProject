//
//  Router.swift
//  FindReserve
//
//  Created by a on 11/6/25.
//

import SwiftUI
import Combine
import MapKit

enum Route: Hashable, Identifiable {
    var id: Self { self }
    
    case mathcing
    case reserveGroup
    case requestPayment(amount: Int)
    case training    
}

class Router: ObservableObject {
    @Published var path: [Route] = []
    @Published var fullScreenPath: [Route] = []
    @Published var fullScreenCover: Route?
    @Published var dismissTrigger = false
    
    func push(_ route: Route) {
        if let fullScreenCover {
            fullScreenPath.append(route)
        } else {
            path.append(route)
        }
    }
    
    func pop() {
        path.popLast()
    }
    
    func popToRoot() {
        path.removeAll()
        dismissTrigger = false
    }
    
    func dismiss() {
        fullScreenCover = nil
    }
    
    func presentFullScreen(_ route: Route) {
        fullScreenCover = route
    }
}
