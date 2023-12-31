//
//  LocationListView.swift
//  DubDubGrub
//
//  Created by Joel Storr on 16.09.23.
//

import SwiftUI

struct LocationListView: View {
    
    @EnvironmentObject private var locationManager: LocationManager
    @StateObject private var viewModel = LocationListViewModel()
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(locationManager.locations){ location in
                    
                    NavigationLink(value: location) {
                        LocationCell(location: location, profiles: viewModel.checkedInProfiles[location.id, default: []])
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(Text(viewModel.createVoiceOverSummary(for: location)))
                    }
                    
//                    NavigationLink( destination: viewModel.createLocationDetailView(for: location, in: dynamicTypeSize)){
//                        LocationCell(location: location, profiles: viewModel.checkedInProfiles[location.id, default: []])
//                            .accessibilityElement(children: .ignore)
//                            .accessibilityLabel(Text(viewModel.createVoiceOverSummary(for: location)))
//                    }
                }
            }
            .task{
                await viewModel.getCheckedInProfilesDictionary()
            }
            .navigationTitle("Grub Spots")
            .navigationDestination(for: DDGLocation.self, destination: { location in
                viewModel.createLocationDetailView(for: location, in: dynamicTypeSize)
            })
            .listStyle(.plain)
            .alert(item: $viewModel.alertItem, content: {$0.alert})
            .refreshable { await viewModel.getCheckedInProfilesDictionary()}
        }
    }
}


