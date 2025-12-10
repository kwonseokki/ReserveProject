//
//  SecondTabRouter.swift
//  FindReserve
//
//  Created by a on 12/10/25.
//

import SwiftUI
import Combine
import MapKit

enum SecondTabRoute: Hashable, Identifiable {
    var id: Self { self }
    case rideDetail
}

class SecondTabRouter: ObservableObject {
    @Published var path: [SecondTabRoute] = []
    @Published var fullScreenPath: [SecondTabRoute] = []
    @Published var fullScreenCover: SecondTabRoute?
    @Published var dismissTrigger = false
    
    func push(_ route: SecondTabRoute) {
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
    
    func presentFullScreen(_ route: SecondTabRoute) {
        fullScreenCover = route
    }
}
