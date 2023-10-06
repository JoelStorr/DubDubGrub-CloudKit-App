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
                    NavigationLink(
                        destination: LocationDetailView(
                            viewModel: LocationDetailViewModel(
                                location: location
                            )
                        )
                    )
                    {
                        LocationCell(location: location)
                    }
                }
            }
            .onAppear{
                CloudKitManager.shared.getCheckedInProfilesDictionary { result in
                    switch result {
                    case .success(let checkedInProfiles):
                        print(checkedInProfiles)
                    case .failure(_):
                        print("Error getting Profiles")
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
