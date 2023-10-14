//
//  LocationMapView.swift
//  DubDubGrub
//
//  Created by Joel Storr on 16.09.23.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct LocationMapView: View {
    
    @EnvironmentObject private var locationManager: LocationManager
    @StateObject private var viewModel = LocationMapViewModel()
    @State private var alertItem: AlertItem?
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View {
        ZStack(alignment: .top){
            
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: locationManager.locations) { location in
                //Simple Map pin
                //MapPin(coordinate: $0.location.coordinate)
                MapAnnotation(
                    coordinate: location.location.coordinate,
                    anchorPoint: CGPoint(x: 0.5, y: 0.75)
                ) {
                    DDGAnnotation(
                        location: location,
                        number: viewModel.checkedInProfiles[location.id, default : 0]
                    )
                    .onTapGesture {
                        locationManager.selectedLocation = location
                        viewModel.isShowingDetailView = true
                    }
                }
            }
            .tint(.grubRed)
            .ignoresSafeArea()
            
            
            LogoView(frameWidth: 125)
                .shadow(radius: 10)
                .accessibilityHidden(true)
            
           
            
            
        }
        .sheet(isPresented: $viewModel.isShowingDetailView) {
            NavigationView{
                viewModel.createLocationDetailView(for: locationManager.selectedLocation!, in: dynamicTypeSize)
                    .toolbar{
                        Button("Dismiss"){
                            viewModel.isShowingDetailView = false
                        }
                    }
            }
        }
        .overlay(alignment: .bottomLeading){
            LocationButton(.currentLocation) {
                viewModel.requestAllowOnceLocationPermission()
            }
            .foregroundColor(.white)
            .symbolVariant(.fill)
            .tint(.grubRed)
            .labelStyle(.iconOnly)
            .clipShape(Circle())
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 0))
        }
        .alert(item: $viewModel.alertItem, content: { $0.alert })
        .onAppear(){
            //Prevents us from loading the Locations each time we go to the view
            if locationManager.locations.isEmpty{
                viewModel.getLocations(for: locationManager)
            }
            viewModel.getCheckedInCount()
        }
    }
}


struct LocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapView().environmentObject(LocationManager())
    }
}
