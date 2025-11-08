//
//  MapView.swift
//  FindReserve
//
//  Created by a on 11/8/25.
//

import SwiftUI
import MapLibre

struct MapView: UIViewRepresentable {
    func makeUIView(context : Context) -> MLNMapView {
        guard let styleURL = Bundle.main.url(forResource: "config-openmaptiles", withExtension: "json") else {
            fatalError("Offline style JSON file not found in bundle.")
        }
        let mapView = MLNMapView(frame: .zero, styleURL: styleURL)
        
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_: MLNMapView, context _: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator: NSObject, MLNMapViewDelegate {
        func mapViewDidFailLoadingMap(_ mapView: MLNMapView, withError error: any Error) {
            print(error)
        }
        func mapView(_ mapView: MLNMapView, didFinishLoading style: MLNStyle) {
            print("View Load")
        }
    }
}
