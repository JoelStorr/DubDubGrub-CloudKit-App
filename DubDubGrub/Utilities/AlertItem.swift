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
    //MARK: -MapView Error
    static let unableToGetLocations = AlertItem(
        title: Text("Locations Error"),
        message: Text("Unabel to retrive locations at this time. \nPleas try again"),
        dismissButton: .default(Text("OK"))
    )
}
