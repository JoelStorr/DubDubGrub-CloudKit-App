//
//  LocationDetailViewModel.swift
//  DubDubGrub
//
//  Created by Joel Storr on 29.09.23.
//

import SwiftUI
import MapKit
import CloudKit

enum checkInStatus { case checkedIn, checkedOut}

final class LocationDetailViewModel: ObservableObject {
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @Published var alertItem: AlertItem?
    @Published var isSHowingProfileModal: Bool = false
    
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
    
    func upadteCheckinStatus(to checkInStatus: checkInStatus){
        //Retrive the DDGProfile
        
        guard let profileRcordID = CloudKitManager.shared.profileRecordID else {
            //Show alert
            return
        }
        
        CloudKitManager.shared.fetchRecord(with: profileRcordID) { [self] result in
            switch result {
            case .success(let record):
                //Create a reference to the location
                switch checkInStatus{
                case .checkedIn:
                    //Update check in Status
                    record[DDGProfile.kIsCheckedIn] = CKRecord.Reference(recordID: location.id, action: .none)
                case .checkedOut:
                    record[DDGProfile.kIsCheckedIn] = nil
                }
                
                //Save the Updated version to CloudKit
                CloudKitManager.shared.save(record: record) { result in
                    
                    switch result{
                    case .success(_):
                        //Update checkd in Profile arry
                        print("✅ Checkd in / out Successfully")
                    case .failure(_):
                        print("❌ Error saving record")
                    }
                }
                
            case .failure(_):
                print("❌ Error fetching record")
            }
        }
        
     
        
        
    }
    
}



