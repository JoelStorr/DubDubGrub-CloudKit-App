//
//  LocationManager.swift
//  DubDubGrub
//
//  Created by Joel Storr on 24.09.23.
//

import Foundation

final class LocationManager: ObservableObject{
    @Published var locations: [DDGLocation] = []
    var selectedLocation: DDGLocation?
}
