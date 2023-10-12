//
//  AppTabViewModel.swift
//  DubDubGrub
//
//  Created by Joel Storr on 08.10.23.
//

import CoreLocation
import SwiftUI


extension AppTabView{
    
    final class AppTabViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
        
        @Published var isShowingOnboardview = false
        @Published var alertItem: AlertItem?
        @AppStorage("hasSeenOnboardView") var hasSeenOnboardView = false {
            didSet {
                isShowingOnboardview = hasSeenOnboardView
            }
        }
        
        var deviceLocationManager: CLLocationManager?
        let kHasSeenTheOnboardView = "hasSeenOnboardView"
        
        
        func runStartUpChecks(){
            if !hasSeenOnboardView {
                hasSeenOnboardView = true
            } else {
                checkIfLocationServicesIsEnabled()
            }
        }
        
        
        func checkIfLocationServicesIsEnabled(){
            if CLLocationManager.locationServicesEnabled() {
                deviceLocationManager = CLLocationManager()
                deviceLocationManager?.desiredAccuracy = kCLLocationAccuracyBest
                deviceLocationManager!.delegate = self
            } else {
                alertItem = AlertContext.locationDisabled
            }
        }
        
        
        //Cheking if the User allowed Location Services
        private func checkForLocationAutorization(){
            guard let deviceLocationManager = deviceLocationManager else { return }
            
            switch deviceLocationManager.authorizationStatus{
                
            case .notDetermined:
                deviceLocationManager.requestWhenInUseAuthorization()
            case .restricted:
                alertItem = AlertContext.locationRestricted
            case .denied:
                alertItem = AlertContext.locationDenied
            case .authorizedAlways, .authorizedWhenInUse:
                break
            @unknown default:
                break
            }
        }
        
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkForLocationAutorization()
        }
    }
}


