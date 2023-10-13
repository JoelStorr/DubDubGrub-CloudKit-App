//
//  ProfileViewModel.swift
//  DubDubGrub
//
//  Created by Joel Storr on 27.09.23.
//

import CloudKit

enum ProfileContext{ case create, update }

final class ProfileViewModel: ObservableObject {
    
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var companyName = ""
    @Published var bio = ""
    @Published var avatar = PlaceholderImage.avatar
    @Published var isShowingPhotoPicker = false
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    @Published var isCheckedIn = false
    
    
    private var existingProfileRecord: CKRecord? {
        didSet{ profileContext = .update }
    }
    
    var profileContext: ProfileContext = .create
    
    func isValidProfile()-> Bool{
        guard !firstName.isEmpty,
              !lastName.isEmpty,
              !companyName.isEmpty,
              !bio.isEmpty,
              avatar != PlaceholderImage.avatar,
              bio.count <= 100 else { return false }
        return true
    }
    
    
    func getCheckedInStatus(){
        guard let profileRcordID = CloudKitManager.shared.profileRecordID else { return }
        CloudKitManager.shared.fetchRecord(with: profileRcordID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let record):
                    if let _ = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference {
                        self.isCheckedIn = true
                    }
                    else {
                        self.isCheckedIn = false
                    }
                case .failure(_):
                    break
                }
            }
        }
    }
    
    
    func checkout(){
        guard let profileID = CloudKitManager.shared.profileRecordID else {
            alertItem = AlertContext.unableToGetProfile
            return
        }
        
        CloudKitManager.shared.fetchRecord(with: profileID) { result in
            switch result {
            case .success(let record):
                record[DDGProfile.kIsCheckedIn] = nil
                record[DDGProfile.kIsCheckedInNilCheck] = nil
                CloudKitManager.shared.save(record: record) { [self] result in
                    
                    DispatchQueue.main.async {
                        switch result {
                        case .success(_):
                            self.isCheckedIn = false
                        case .failure(_):
                            self.alertItem = AlertContext.unableToCheckInOrOut
                        }
                    }
                }
            case .failure(_):
                
                DispatchQueue.main.async {
                    self.alertItem = AlertContext.unableToCheckInOrOut
                }
            }
        }
        
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
                case .success(let records):
                    for record in records where record.recordType == RecordType.profile{
                        existingProfileRecord = record
                        CloudKitManager.shared.profileRecordID = record.recordID
                    }
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
                    existingProfileRecord = record
                    //Mathch Server data to UI State varaibles
                    let profile = DDGProfile(record: record)
                    firstName = profile.firstName
                    lastName = profile.lastName
                    companyName = profile.companyName
                    bio = profile.bio
                    avatar = profile.avatarImage
                case .failure(_):
                    alertItem = AlertContext.unableToGetProfile
                    return
                }
            }
        }
    }
    
    
    func upadteProfile(){
        guard isValidProfile() else {
            alertItem = AlertContext.invalidProfile
            return
        }
        
        guard let profileRecord = existingProfileRecord else {
            alertItem = AlertContext.unableToGetProfile
            return
        }
        
        profileRecord[DDGProfile.kFirstName] = firstName
        profileRecord[DDGProfile.kLastName] = lastName
        profileRecord[DDGProfile.kCompanyName] = companyName
        profileRecord[DDGProfile.kBio] = bio
        profileRecord[DDGProfile.kAvatar] = avatar.convertToCKAsset()
        
        showLoadingView()
        CloudKitManager.shared.save(record: profileRecord) { result in
            
            DispatchQueue.main.async { [self] in
                hideLoadingView()
                switch result {
                case .success(_):
                    alertItem = AlertContext.updateProfileSuccess
                case .failure(_):
                    alertItem = AlertContext.updateProfileFailure
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
