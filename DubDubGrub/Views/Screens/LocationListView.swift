//
//  LocationListView.swift
//  DubDubGrub
//
//  Created by Joel Storr on 16.09.23.
//

import SwiftUI

struct LocationListView: View {
    
    
    @EnvironmentObject private var locationManager: LocationManager
    
    
    var body: some View {
        NavigationView{
            
            
            List{
                ForEach(locationManager.locations){ location in
                    NavigationLink(destination: LocationDetailView(location: location)) {
                        LocationCell(location: location)
                    }
                }
            }
                .navigationTitle("Grub Spots")
            
            
            
        }
    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView()
    }
}
