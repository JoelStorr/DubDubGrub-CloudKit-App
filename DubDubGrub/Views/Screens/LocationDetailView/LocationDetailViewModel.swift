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


extension LocationDetailView {
    
   @MainActor final class LocationDetailViewModel: ObservableObject {
        
        
        @Published var checkedInProfiles: [DDGProfile] = []
        @Published var isLoading = false
        @Published var isShowingProfileModal: Bool = false
        @Published var isShowingProfileSheet: Bool = false
        @Published var isCheckedIn = false
        @Published var alertItem: AlertItem?
        
        var location : DDGLocation
        var selectedProfile : DDGProfile?
        var buttonColor: Color {isCheckedIn ? .grubRed : .brandPrimary}
        var buttonImageTitle: String {isCheckedIn ? "person.fill.xmark" :  "person.fill.checkmark"}
        var buttonA11yLabel: String {isCheckedIn ? "Check out of location" :  "Check in to location"}
        
        
        init(location: DDGLocation){
            self.location = location
        }
        
        
        func determinColumns(for dynamicTypeSize: DynamicTypeSize) -> [GridItem]{
            let numberOfColumns = dynamicTypeSize >= .accessibility3 ? 1 : 3
            return Array(repeating: GridItem(.flexible()), count: numberOfColumns)
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
        
        
        func getCheckedInStatus(){
            guard let profileRcordID = CloudKitManager.shared.profileRecordID else { return }
            
            Task{
                do{
                    let record = try await CloudKitManager.shared.fetchRecord(with: profileRcordID)
                    if let reference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference {
                        self.isCheckedIn = reference.recordID == self.location.id
                    }
                    else {
                        self.isCheckedIn = false
                    }
                }catch {
                    alertItem = AlertContext.unableToGetCheckedInStatus
                }
            }
        }
        
        
        func upadteCheckinStatus(to checkInStatus: checkInStatus){
            //Retrive the DDGProfile
            guard let profileRcordID = CloudKitManager.shared.profileRecordID else {
                alertItem = AlertContext.unableToGetProfile
                return
            }
            showLoadingView()
            
            Task{
                do{
                    let record = try await CloudKitManager.shared.fetchRecord(with: profileRcordID)
                    //Create a reference to the location
                    switch checkInStatus{
                    case .checkedIn:
                        //Update check in Status
                        record[DDGProfile.kIsCheckedIn] = CKRecord.Reference(recordID: location.id, action: .none)
                        record[DDGProfile.kIsCheckedInNilCheck] = 1
                    case .checkedOut:
                        record[DDGProfile.kIsCheckedIn] = nil
                        record[DDGProfile.kIsCheckedInNilCheck] = nil
                    }
                    
                    let savedRecord = try await CloudKitManager.shared.save(record: record)
                    
                    HapticManager.playSuccess()
                    let profile = DDGProfile(record: savedRecord)
                    
                    switch checkInStatus{
                        
                    case .checkedIn:
                        //Update checkd in Profile arry
                        self.checkedInProfiles.append(profile)
                    case .checkedOut:
                        self.checkedInProfiles.removeAll(where: {$0.id == profile.id})
                    }
                    
                    self.isCheckedIn.toggle()
                    hideLoadingView()
                } catch {
                    hideLoadingView()
                    alertItem = AlertContext.unableToCheckInOrOut
                }
            }
        }
        
        
        func getCheckedInProfiles(){
            showLoadingView()
            Task{
                do {
                    checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfiles(for: location.id)
                    hideLoadingView()
                } catch {
                    alertItem = AlertContext.unableToGetCheckedInProfiles
                    hideLoadingView()
                }
            }
        }
        
        
        func show(_ profile: DDGProfile, in dynamicTypeSize: DynamicTypeSize) {
            selectedProfile = profile
            if dynamicTypeSize >= .accessibility3 {
                isShowingProfileSheet = true
            }else {
                isShowingProfileModal = true
            }
        }
        
        
        private func showLoadingView() { isLoading = true }
        private func hideLoadingView() { isLoading = false }
        
    }
}



