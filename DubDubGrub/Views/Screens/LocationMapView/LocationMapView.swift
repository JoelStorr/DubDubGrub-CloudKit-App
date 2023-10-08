//
//  LocationMapView.swift
//  DubDubGrub
//
//  Created by Joel Storr on 16.09.23.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    
    @EnvironmentObject private var locationManager: LocationManager
    
   @StateObject private var viewModel = LocationMapViewModel()
    
    @State private var alertItem: AlertItem?
    
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: locationManager.locations) { location in
                //Simple Map pin
                //MapPin(coordinate: $0.location.coordinate)
                MapAnnotation(
                    coordinate: location.location.coordinate,
                    anchorPoint: CGPoint(x: 0.5, y: 0.75)
                ) {
                    DDGAnnotation(location: location)
                        .onTapGesture {
                            locationManager.selectedLocation = location
                            viewModel.isShowingDetailView = true
                        }
                }
                   
            }
            .accentColor(.grubRed)
            .ignoresSafeArea()
            
            VStack{
                LogoView(frameWidth: 125)
                    .shadow(radius: 10)
                Spacer()
            }
        }
        .sheet(isPresented: $viewModel.isShowingDetailView) {
            NavigationView{
                LocationDetailView(viewModel: LocationDetailViewModel(location: locationManager.selectedLocation!))
                    .toolbar{
                        Button("Dismiss"){
                            viewModel.isShowingDetailView = false
                        }
                    }
            }
            .accentColor(.brandPrimary)
        }
        .alert(item: $viewModel.alertItem, content: { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        })
        .onAppear(){
            //Prevents us from loading the Locations each time we go to the view
            if locationManager.locations.isEmpty{
                viewModel.getLocations(for: locationManager)
            }
        }
    }
}

struct LocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapView()
    }
}



