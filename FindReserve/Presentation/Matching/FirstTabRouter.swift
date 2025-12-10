//
//  Router.swift
//  FindReserve
//
//  Created by a on 11/6/25.
//

import SwiftUI
import Combine
import MapKit

enum FirstTabRoute: Hashable, Identifiable {
    var id: Self { self }
    
    case mathcing
    case reserveGroup
    case requestPayment(amount: Int)
    case training
    case rideDetail
}

class FirstTabRouter: ObservableObject {
    @Published var path: [FirstTabRoute] = []
    @Published var fullScreenPath: [FirstTabRoute] = []
    @Published var fullScreenCover: FirstTabRoute?
    @Published var dismissTrigger = false
    
    func push(_ route: FirstTabRoute) {
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
    
    func presentFullScreen(_ route: FirstTabRoute) {
        fullScreenCover = route
    }
}
