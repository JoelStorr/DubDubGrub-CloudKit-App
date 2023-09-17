//
//  AppTabView.swift
//  DubDubGrub
//
//  Created by Joel Storr on 16.09.23.
//

import SwiftUI

struct AppTabView: View {
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
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .accentColor(.brandPrimary)
        .tabViewDefaultBackground()
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
