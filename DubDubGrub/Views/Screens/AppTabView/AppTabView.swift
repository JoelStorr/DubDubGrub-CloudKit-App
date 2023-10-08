//
//  AppTabView.swift
//  DubDubGrub
//
//  Created by Joel Storr on 16.09.23.
//

import SwiftUI

struct AppTabView: View {
    
    
    @StateObject private var viewModel = AppTabViewModel()
    
    
    var body: some View {
        TabView{
            LocationMapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            LocationListView()
                .tabItem {
                    Label("Locations", systemImage: "building")
                }
            
            NavigationView{
                ProfileView()
            }
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .onAppear{
            CloudKitManager.shared.getUserRecord()
            viewModel.runStartUpChecks()
        }
        .accentColor(.brandPrimary)
        .sheet(isPresented: $viewModel.isShowingOnboardview, onDismiss: viewModel.checkIfLocationServicesIsEnabled) {
            OnboardView(isShowingOnboardView: $viewModel.isShowingOnboardview)
        }
        .tabViewDefaultBackground()
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
