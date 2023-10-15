//
//  ProfileViewModel.swift
//  DubDubGrub
//
//  Created by Joel Storr on 27.09.23.
//

import CloudKit

enum ProfileContext{ case create, update }


extension ProfileView {
    
   @MainActor final class ProfileViewModel: ObservableObject {
        
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
        var buttonTitle: String { profileContext == .create ? "Create Profile" : "Update Profile" }
        
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
            
            Task{
                do{
                    let record = try await CloudKitManager.shared.fetchRecord(with: profileRcordID)
                    if let _ = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference {
                        self.isCheckedIn = true
                    }
                    else {
                        self.isCheckedIn = false
                    }
                } catch {
                    print("Unable to get checkd in Status")
                }
            }
        }
        
        
        func checkout(){
            guard let profileID = CloudKitManager.shared.profileRecordID else {
                alertItem = AlertContext.unableToGetProfile
                return
            }
            
            showLoadingView()
            
            Task{
                do{
                    let record = try await CloudKitManager.shared.fetchRecord(with: profileID)
                    record[DDGProfile.kIsCheckedIn] = nil
                    record[DDGProfile.kIsCheckedInNilCheck] = nil
                    
                    let _ = try await CloudKitManager.shared.save(record: record)
                    HapticManager.playSuccess()
                    isCheckedIn = false
                    
                    hideLoadingView()
                    
                }catch{
                    hideLoadingView()
                    alertItem = AlertContext.unableToCheckInOrOut
                }
            }
        }
        
        func determineButtonAction(){
            profileContext == .create ? createProfile() : upadteProfile()
        }
        
        
      private  func createProfile(){
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
            
          Task{
              do{
                  let records = try await CloudKitManager.shared.batchSave(records: [userRecord, profileRecord])
                  for record in records where record.recordType == RecordType.profile{
                      existingProfileRecord = record
                      CloudKitManager.shared.profileRecordID = record.recordID
                  }
                  hideLoadingView()
                  alertItem = AlertContext.createProfileSuccess
              }catch {
                  hideLoadingView()
                  alertItem = AlertContext.createProfileFailure
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
            
            
            Task{
                do{
                    let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
                    existingProfileRecord = record
                    //Mathch Server data to UI State varaibles
                    let profile = DDGProfile(record: record)
                    firstName = profile.firstName
                    lastName = profile.lastName
                    companyName = profile.companyName
                    bio = profile.bio
                    avatar = profile.avatarImage
                    hideLoadingView()
                }catch{
                    hideLoadingView()
                    alertItem = AlertContext.unableToGetProfile
                }
            }
        }
        
        
       private func upadteProfile(){
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
           
           Task{
               do{
                   let _ = try await CloudKitManager.shared.save(record: profileRecord)
                   alertItem = AlertContext.updateProfileSuccess
                   hideLoadingView()
               } catch{
                   hideLoadingView()
                   alertItem = AlertContext.updateProfileFailure
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
}

