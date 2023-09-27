//
//  AlertItem.swift
//  DubDubGrub
//
//  Created by Joel Storr on 22.09.23.
//

import SwiftUI

struct AlertItem: Identifiable{
    let id = UUID()
    
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}


struct AlertContext{
    //MARK: -MapView Errors
    static let unableToGetLocations = AlertItem(
        title: Text("Locations Error"),
        message: Text("Unabel to retrive locations at this time. \nPleas try again"),
        dismissButton: .default(Text("OK"))
    )
    
    static let locationRestricted = AlertItem(
        title: Text("Locations Restricted"),
        message: Text("Your location is restricted. This may be due to parental controls."),
        dismissButton: .default(Text("OK"))
    )
    static let locationDenied = AlertItem(
        title: Text("Locations Denied"),
        message: Text("Dub Dub Grub does not have permission to access your location. To chnage that goe to your device Settings > DubDubGrub > Location"),
        dismissButton: .default(Text("OK"))
    )
    static let locationDisabled = AlertItem(
        title: Text("Locations Service Disabled"),
        message: Text("Your phones location services are disabled. To chnage that goe to your device Settings > Privacy > Location Services"),
        dismissButton: .default(Text("OK"))
    )
    
    
    //MARK: ProfileView Errors
    static let invalidProfile = AlertItem(
        title: Text("Invalid Profile"),
        message: Text("All fields are requierd, as well as a profile photo. Your bio must be < 100 characters. \nPlease try again."),
        dismissButton: .default(Text("OK"))
    )
    
}
