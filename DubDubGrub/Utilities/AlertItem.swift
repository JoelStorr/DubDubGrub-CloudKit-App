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
    
    static let noUserRecord = AlertItem(
        title: Text("No User Record"),
        message: Text("You must log into iCloud on your phoen in order to utilize Dub Dub Grub's profiel. Pleas log in on your phone's settings screen."),
        dismissButton: .default(Text("OK"))
    )
    
    static let createProfileSuccess = AlertItem(
        title: Text("Profile Created Successfully."),
        message: Text("Your profile has successfully been created."),
        dismissButton: .default(Text("OK"))
    )
    
    static let createProfileFailure = AlertItem(
        title: Text("Failed to Create Profile"),
        message: Text("We were unabel to create your profile at this time.\n Pleas try again later or contact customer support if this persists."),
        dismissButton: .default(Text("OK"))
    )
    
    static let unableToGetProfile = AlertItem(
        title: Text("Unable To Retrieve Profile"),
        message: Text("We were unabel to retrieve your profile at this time.\n Pleas try again later or contact customer support if this persists."),
        dismissButton: .default(Text("OK"))
    )
    
    static let updateProfileSuccess = AlertItem(
        title: Text("Profile Update Success"),
        message: Text("Your Dub Dub Grub Profile was updated successfully."),
        dismissButton: .default(Text("OK"))
    )
    
    static let updateProfileFailure = AlertItem(
        title: Text("Profile Update Failed"),
        message: Text("We were unable to update your profile at this time.\nPlease try again later"),
        dismissButton: .default(Text("OK"))
    )
    
    
    //MARK: Location Detail Screen
    static let invalidPhoneNumber = AlertItem(
        title: Text("Invalid Phone Number"),
        message: Text("The phonen number for the location is invalid"),
        dismissButton: .default(Text("OK"))
    )
    
    static let phoneUnsupportedDevice = AlertItem(
        title: Text("You can't call from this device"),
        message: Text("You can't call from this device. Please use a iPhone to call from"),
        dismissButton: .default(Text("OK"))
    )
    
    static let unableToGetCheckedInStatus = AlertItem(
        title: Text("Server Error"),
        message: Text("Unable to retrive checked in Status of the current user. \nPlease try again."),
        dismissButton: .default(Text("OK"))
    )
    
    static let unableToCheckInOrOut = AlertItem(
        title: Text("Server Error"),
        message: Text("Unable to check in or out at this time. \nPlease try again."),
        dismissButton: .default(Text("OK"))
    )
    
    static let unableToGetCheckedInProfiles = AlertItem(
        title: Text("Server Error"),
        message: Text("Unable to get the checked in users at this time. \nPlease try again."),
        dismissButton: .default(Text("OK"))
    )
}
