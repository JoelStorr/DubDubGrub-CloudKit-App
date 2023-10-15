//
//  CloudKitManager.swift
//  DubDubGrub
//
//  Created by Joel Storr on 21.09.23.
//

import CloudKit

final class CloudKitManager{
    
    static let shared = CloudKitManager()
    
    private init(){}
    
    var userRecord: CKRecord?
    var profileRecordID: CKRecord.ID?
    let container = CKContainer.default()
    
    
    func getUserRecord() async throws {
        
        //Either returns ID or throws an error
        let recordID = try await container.userRecordID()
        let record = try await container.publicCloudDatabase.record(for: recordID)
        userRecord = record
        
        //If we have a user Profile set the reference id
        if let profileReference = record["userProfile"] as? CKRecord.Reference {
            profileRecordID = profileReference.recordID
        }
    }
    
    
//  NOTE: Old way
//    func getUserRecord(){
//        //Get the User Record ID from Container
//        CKContainer.default().fetchUserRecordID { recordID, error in
//            guard let recordID = recordID, error == nil else {
//                print(error!.localizedDescription)
//                return
//            }
//            //Get Userrecord from the Public Database
//            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { userRecord, error in
//                guard let userRecord = userRecord, error == nil else {
//                    print(error!.localizedDescription)
//                    return
//                }
//                self.userRecord = userRecord
//                
//                //If we have a user Profile set the reference id
//                if let profileReference = userRecord["userProfile"] as? CKRecord.Reference {
//                    self.profileRecordID = profileReference.recordID
//                }
//            }
//        }
//    }
    
    
    func getLocations() async throws -> [DDGLocation] {
        //Sorts the Elements by Name in a decending order
        let alphabeticalSort = NSSortDescriptor(key: DDGLocation.kName, ascending: true)
        
        //Uses Convinience API
        //Query: return all DDGLocations
        let query = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
        query.sortDescriptors = [alphabeticalSort]
        
        
        //(results, cursor) we don't use cursor in this function
        let (matchResult, _) = try await container.publicCloudDatabase.records(matching: query)
        let records = matchResult.compactMap { _, result in
            try? result.get()
        }
        
        return records.map(DDGLocation.init) 
    }
      
    
//      NOTE: Old way
//        func getLocations(completed: @escaping (Result<[DDGLocation], Error>) -> Void) {
//            //Sorts the Elements by Name in a decending order
//            let alphabeticalSort = NSSortDescriptor(key: DDGLocation.kName, ascending: true)
//            
//            //Uses Convinience API
//            //Query: return all DDGLocations
//            let query = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
//            query.sortDescriptors = [alphabeticalSort]
//            
//            //Fetches data from the DB
//            CKContainer.default().publicCloudDatabase.fetch(withQuery: query, inZoneWith: nil) { result in
//                switch result {
//                case .failure(let error):
//                    completed(.failure(error))
//                    return
//                case .success((let matchResults, _)):
//                    
//                    var locations: [DDGLocation] = []
//                    
//                    for matchResult in matchResults {
//                        switch matchResult.1 {
//                        case .success(let record):
//                            let location = DDGLocation(record: record)
//                            locations.append(location)
//                        case .failure(let error):
//                            print("Error: \(error)")
//                            return
//                        }
//                    }
//                    completed(.success(locations))
//                }
//            }
//    }
        
    
    func getCheckedInProfiles(for locationID : CKRecord.ID) async  throws -> [DDGProfile] {
        
        let reference = CKRecord.Reference(recordID: locationID, action: .none)
        let predicate = NSPredicate(format: "isCheckedIn == %@", reference)
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        
        
        let (matchResult, _) = try await container.publicCloudDatabase.records(matching: query)
        let records = matchResult.compactMap{ _, result in try? result.get() }
        
        return records.map(DDGProfile.init)
    }
    
    
    //Old way
//    func getCheckedInProfiles(for locationID : CKRecord.ID, completed: @escaping(Result<[DDGProfile], Error>)->Void){
//        let reference = CKRecord.Reference(recordID: locationID, action: .none)
//        let predicate = NSPredicate(format: "isCheckedIn == %@", reference)
//        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
//        
//        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil){ records, error in
//            guard let records = records, error == nil else {
//                completed(.failure(error!))
//                return
//            }
//            
//            let profiles = records.map(DDGProfile.init)
//            completed(.success(profiles))
//        }
//    }
    
    
    func getCheckedInProfilesDictionary() async throws -> [CKRecord.ID: [DDGProfile]]{
        
    
        let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        //We can also filter the keys we want to get back
        //operation.desiredKeys = [DDGProfile.kIsCheckedIn, DDGProfile.kAvatar]
        
        var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
        
        let (matchresults, cursor) = try await container.publicCloudDatabase.records(matching: query) //Can also have the result limit directly in here
        let records = matchresults.compactMap{ _, result in try? result.get() }
        
        
        for record in records {
            // Building the dictionary
            let profile = DDGProfile(record: record)
            guard let locationReference = record[DDGProfile.kIsCheckedIn]  as? CKRecord.Reference else { continue }
            checkedInProfiles[locationReference.recordID, default: []].append(profile)
        }
        
    
        guard let cursor else {
            return checkedInProfiles
        }
        
        do{
            //Calls the Continue function if there is a cursor
            return try await continueWithCheckedInProfilesDict(cursor: cursor, dictionary: checkedInProfiles)
        } catch {
          throw error
        }
      
    }
    
    
    //Handles code pagination via cursor
    private func continueWithCheckedInProfilesDict( cursor: CKQueryOperation.Cursor, dictionary: [CKRecord.ID: [DDGProfile]]) async throws -> [CKRecord.ID: [DDGProfile]]{
        
        var checkedInProfiles = dictionary

        
        let (matchResult, cursor) = try await container.publicCloudDatabase.records(continuingMatchFrom: cursor) //Can also have the result limit directly in here
        let records = matchResult.compactMap{_, result in try? result.get()}
        
        for record in records {
            // Building the dictionary
            let profile = DDGProfile(record: record)
            guard let locationReference = record[DDGProfile.kIsCheckedIn]  as? CKRecord.Reference else { continue }
            checkedInProfiles[locationReference.recordID, default: []].append(profile)
        }
     
        
        guard let cursor else { return checkedInProfiles}
        
        do{
            // Calls it self recursive untill there is no cursor any more
            return try await continueWithCheckedInProfilesDict(cursor: cursor, dictionary: checkedInProfiles)
        } catch {
          throw error
        }
    }
    
    
    //Get a dictionary of how many people are checked into a given lcation
    func getCheckedInProfilesCount() async throws -> [CKRecord.ID: Int] {
        let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        var checkedInProfiles: [CKRecord.ID: Int] = [:]
        
        
        let (matchResults, _) = try await container.publicCloudDatabase.records(matching: query, desiredKeys: [DDGProfile.kIsCheckedIn])
        let records = matchResults.compactMap{_, result in try? result.get()}
        
        
        for record in records {
            // Building the dictionary
            guard let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else { continue }
            
            if let count = checkedInProfiles[locationReference.recordID] {
                checkedInProfiles[locationReference.recordID] = count + 1
            }else {
                checkedInProfiles[locationReference.recordID] = 1
            }
        }
        return checkedInProfiles
    }
    
    
    func batchSave(records: [CKRecord]) async throws -> [CKRecord]{
        let (savedResult, _ ) = try await container.publicCloudDatabase.modifyRecords(saving: records, deleting: [])
        return savedResult.compactMap{_, result in try? result.get()}
    }
    
    
    func save(record: CKRecord) async throws -> CKRecord{
        return try await container.publicCloudDatabase.save(record)
    }
    
    
    func fetchRecord(with id: CKRecord.ID) async throws -> CKRecord{
        return try await container.publicCloudDatabase.record(for: id)
    }
}

