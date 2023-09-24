//
//  LocationMapViewModel.swift
//  DubDubGrub
//
//  Created by Joel Storr on 23.09.23.
//

import MapKit



final class LocationMapViewModel: NSObject, ObservableObject {
    
    @Published var alertItem: AlertItem?
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 37.331516,
            longitude: -121.891054
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.01,
            longitudeDelta: 0.01
        )
    )
    
    
    var deviceLocationManager: CLLocationManager?
    
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
    

    
    func getLocations(for locationManager: LocationManager){
        CloudKitManager.getLocations { [self] result in
            DispatchQueue.main.async{
                switch result {
                case .success(let locations):
                    locationManager.locations = locations
                case .failure(_):
                    self.alertItem = AlertContext.unableToGetLocations
                }
            }
            
        }
    }
    
    
}


extension LocationMapViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkForLocationAutorization()
    }
}
