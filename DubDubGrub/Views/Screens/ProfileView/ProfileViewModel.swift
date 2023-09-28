//
//  ProfileViewModel.swift
//  DubDubGrub
//
//  Created by Joel Storr on 27.09.23.
//

import CloudKit


final class ProfileViewModel: ObservableObject {
    
    
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var companyName = ""
    @Published var bio = ""
    @Published var avatar = PlaceholderImage.avatar
    @Published var isShowingPhotoPicker = false
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    
    func isValidProfile()-> Bool{
        guard !firstName.isEmpty,
              !lastName.isEmpty,
              !companyName.isEmpty,
              !bio.isEmpty,
              avatar != PlaceholderImage.avatar,
              bio.count <= 100 else { return false }
        return true
    }
    
    
    func createProfile(){
        guard isValidProfile() else {
            alertItem = AlertContext.invalidProfile
            return
        }
        
        //Create CKRecord from profile view
        let profileRecord = createProfileRecord()
        
        
        //Rewrite with CLoud Kit Manager
        guard let userRecord = CloudKitManager.shared.userRecord else {
            alertItem = AlertContext.noUserRecord
            return
        }
        //Create reference on UserRecord to the DDGProfile we created
        //.deleteSelf will delete the Profile when the userRercord gets deleted
        userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
        
        showLoadingView()
        
        CloudKitManager.shared.batchSave(records: [userRecord, profileRecord]) { result in
            
            DispatchQueue.main.async{ [self] in
                hideLoadingView()
                switch result{
                case .success(_):
                    alertItem = AlertContext.createProfileSuccess
                case .failure(_):
                    alertItem = AlertContext.createProfileFailure
                    break
                }
            }
            
        }
        
    }
    func getProfile(){
        
        
        guard let userRecord = CloudKitManager.shared.userRecord else {
            alertItem = AlertContext.noUserRecord
            return
        }
        
        //The record ID that points to the profille we want
        guard let profileReference = userRecord["userProfile"] as? CKRecord.Reference else { return }
        let profileRecordID = profileReference.recordID
        
        showLoadingView()
        
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { result in
            
            DispatchQueue.main.async { [self] in
                hideLoadingView()
                switch result{
                case .success(let record):
                    //Mathch Server data to UI State varaibles
                    let profile = DDGProfile(record: record)
                    firstName = profile.firstName
                    lastName = profile.lastName
                    companyName = profile.companyName
                    bio = profile.bio
                    avatar = profile.createAvatarImage()
                case .failure(_):
                    alertItem = AlertContext.unableToGetProfile
                    return
                }
            }
        }
    }
    
    
    private func createProfileRecord() -> CKRecord {
        //Create CKRecord from profile view
        let profileRecord = CKRecord(recordType: RecordType.profile)
        profileRecord[DDGProfile.kFirstName] = firstName
        profileRecord[DDGProfile.kLastName] = lastName
        profileRecord[DDGProfile.kCompanyName] = companyName
        profileRecord[DDGProfile.kBio] = bio
        profileRecord[DDGProfile.kAvatar] = avatar.convertToCKAsset()
        
        return profileRecord
    }
    
    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
    
    
}
