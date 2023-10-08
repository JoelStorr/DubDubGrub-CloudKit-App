//
//  LocationListViewModel.swift
//  DubDubGrub
//
//  Created by Joel Storr on 06.10.23.
//

import CloudKit

final class LocationListViewModel: ObservableObject{

    @Published var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
    
    func getCheckedInProfilesDictionary(){
        CloudKitManager.shared.getCheckedInProfilesDictionary { result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let checkedInProfiles):
                    self.checkedInProfiles = checkedInProfiles
                case .failure(_):
                    print("Error getting Profiles")
                }
            }
        }
    }
}
