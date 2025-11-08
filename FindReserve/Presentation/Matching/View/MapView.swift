//
//  MapView.swift
//  FindReserve
//
//  Created by a on 11/8/25.
//

import SwiftUI
import MapLibre

struct MapView: UIViewRepresentable {
    @Binding var currentLocation: CLLocationCoordinate2D
    
    func makeUIView(context : Context) -> MLNMapView {
        let mapView = MLNMapView(frame: .zero, styleURL: getLocalStyleURL())
        
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = context.coordinator
        mapView.isPitchEnabled = false
        return mapView
    }
    
    private func getLocalStyleURL() -> URL? {
        
        guard let localMbtilesURL = Bundle.main.url(forResource: "osm-2020-02-10-v3.11_south-korea_seoul", withExtension: "mbtiles") else {
            print("failed to load map")
            return nil
        }
        
        guard let path = Bundle.main.path(forResource: "config-openmaptiles", ofType: "json") else {
            print("failed to load style")
            return nil
        }
        
        do {
            var styleJSON = try String(contentsOfFile: path, encoding: .utf8)
            
            // 절대경로 문자열 추출
            let localPathString = localMbtilesURL.path
            
            // JSON에 절대 경로 문자열을 삽입
            styleJSON = styleJSON.replacingOccurrences(of: "{{LOCAL_FILE_PATH_WITHOUT_PREFIX}}", with: localPathString)
            
            let temporaryDirectory = FileManager.default.temporaryDirectory
            let temporaryFileURL = temporaryDirectory.appendingPathComponent("temp_final_style.json")
            try styleJSON.write(to: temporaryFileURL, atomically: true, encoding: .utf8)
            
            return temporaryFileURL
            
        } catch {
            print("ERROR: \(error)")
            return nil
        }
    }
    
    func updateUIView(_ mapView: MLNMapView, context: Context) {
        context.coordinator.changedLocation(mapView, currentLocation)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(currentLocation: currentLocation)
    }
    
    class Coordinator: NSObject, MLNMapViewDelegate {
        private let currentLocation: CLLocationCoordinate2D
        
        init(currentLocation: CLLocationCoordinate2D) {
            self.currentLocation = currentLocation
        }
        
        func mapViewDidFailLoadingMap(_ mapView: MLNMapView, withError error: any Error) {
            print(error)
        }
        
        func changedLocation(_ mapView: MLNMapView, _ location: CLLocationCoordinate2D) {
            mapView.setCamera(MLNMapCamera(lookingAtCenter: location, altitude: 2000, pitch: 3, heading: 3), animated: false)
        }
        
        func mapView(_ mapView: MLNMapView, didFinishLoading style: MLNStyle) {
            print("View Load")
        }
        
        func mapViewDidFinishRenderingMap(_ mapView: MLNMapView, fullyRendered: Bool) {
            mapView.setCamera(MLNMapCamera(lookingAtCenter: currentLocation, altitude: 2000, pitch: 3, heading: 3), animated: false)
        }
    }
}
