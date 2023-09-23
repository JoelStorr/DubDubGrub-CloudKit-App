//
//  LocationMapView.swift
//  DubDubGrub
//
//  Created by Joel Storr on 16.09.23.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    
   @StateObject private var viewModel = LocationMapViewModel()
    
    @State private var alertItem: AlertItem?
    
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $viewModel.region).ignoresSafeArea()
            
            VStack{
                LogoView().shadow(radius: 10)
                Spacer()
            }
        }
        .alert(item: $viewModel.alertItem, content: { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        })
        .onAppear(){
            viewModel.getLocations()
        }
    }
}

struct LocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapView()
    }
}


struct LogoView : View {
    var body: some View {
        Image("ddg-map-logo")
            .resizable()
            .scaledToFit()
            .frame(height: 70)
    }
}