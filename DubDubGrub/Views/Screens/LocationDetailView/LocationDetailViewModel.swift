//
//  LocationDetailViewModel.swift
//  DubDubGrub
//
//  Created by Joel Storr on 29.09.23.
//

import SwiftUI
import MapKit


final class LocationDetailViewModel: ObservableObject {
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @Published var alertItem: AlertItem?
    
    var location : DDGLocation
    
    
    init(location: DDGLocation){
        self.location = location
    }
    
    
    func getDirectionToLocation(){
        
        let placeMark = MKPlacemark(coordinate: location.location.coordinate)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = location.name
        
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
        ])
    }
    
    
    func callLocation(){
        
        //replace with location.phoneNumber
        guard let url = URL(string: "tel://\("000000000000")") else { 
            alertItem = AlertContext.invalidPhoneNumber
            return }
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url)
        } else {
            alertItem = AlertContext.phoneUnsupportedDevice
            return
        }
    }
    
    
}



