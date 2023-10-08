//
//  AppTabViewModel.swift
//  DubDubGrub
//
//  Created by Joel Storr on 08.10.23.
//

import CoreLocation

final class AppTabViewModel: NSObject, ObservableObject{
    
    @Published var isShowingOnboardview = false
    @Published var alertItem: AlertItem?
    
    var deviceLocationManager: CLLocationManager?
    
    let kHasSeenTheOnboardView = "hasSeenOnboardView"
    var hasSeenOnboardView: Bool {
        //Retunrs false if nothing is thre
        return UserDefaults.standard.bool(forKey: kHasSeenTheOnboardView)
    }
    
    
    func runStartUpChecks(){
        if !hasSeenOnboardView {
            isShowingOnboardview = true
            UserDefaults.standard.set(true, forKey: kHasSeenTheOnboardView)
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
}

extension AppTabViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkForLocationAutorization()
    }
}
