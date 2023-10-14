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
    
    
    func getUserRecord(){
        //Get the User Record ID from Container
        CKContainer.default().fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                print(error!.localizedDescription)
                return
            }
            //Get Userrecord from the Public Database
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { userRecord, error in
                guard let userRecord = userRecord, error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                self.userRecord = userRecord
                
                //If we have a user Profile set the reference id
                if let profileReference = userRecord["userProfile"] as? CKRecord.Reference {
                    self.profileRecordID = profileReference.recordID
                }
            }
        }
    }
    
    
    func getLocations(completed: @escaping (Result<[DDGLocation], Error>) -> Void) {
        //Sorts the Elements by Name in a decending order
        let alphabeticalSort = NSSortDescriptor(key: DDGLocation.kName, ascending: true)
        
        //Uses Convinience API
        //Query: return all DDGLocations
        let query = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
        query.sortDescriptors = [alphabeticalSort]
        
        //Fetches data from the DB
        CKContainer.default().publicCloudDatabase.fetch(withQuery: query, inZoneWith: nil) { result in
            switch result {
            case .failure(let error):
                completed(.failure(error))
                return
            case .success((let matchResults, _)):
                
                var locations: [DDGLocation] = []
                
                for matchResult in matchResults {
                    switch matchResult.1 {
                    case .success(let record):
                        let location = DDGLocation(record: record)
                        locations.append(location)
                    case .failure(let error):
                        print("Error: \(error)")
                        return
                    }
                }
                completed(.success(locations))
            }
        }
        
        /* Depricated:
         //Using the Query
         CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
         //Check if there are any errors
         guard error == nil else {
         completed(.failure(error!))
         return
         }
         
         //Check if we have data
         guard records == records else {
         return
         }
         
         
         var locations: [DDGLocation] = []
         
         //Transforms record types into DDGLoaction Types
         for record in records! {
         let location = DDGLocation(record: record)
         locations.append(location)
         }
         
         completed(.success(locations))
         
         }
         
         
         */
    }
    
    
    func getCheckedInProfiles(for locationID : CKRecord.ID, completed: @escaping(Result<[DDGProfile], Error>)->Void){
        let reference = CKRecord.Reference(recordID: locationID, action: .none)
        let predicate = NSPredicate(format: "isCheckedIn == %@", reference)
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil){ records, error in
            guard let records = records, error == nil else {
                completed(.failure(error!))
                return
            }
            
            let profiles = records.map(DDGProfile.init)
            completed(.success(profiles))
        }
    }
    
    
    func getCheckedInProfilesDictionary(completed: @escaping(Result<[CKRecord.ID: [DDGProfile]], Error>)->Void){
        
        print("✅ Network call fired off")
        let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        //We can also filter the keys we want to get back
        //operation.desiredKeys = [DDGProfile.kIsCheckedIn, DDGProfile.kAvatar]
        
        var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
        operation.recordFetchedBlock = { record in
            // Building the dictionary
            let profile = DDGProfile(record: record)
            guard let locationReference = record[DDGProfile.kIsCheckedIn]  as? CKRecord.Reference else { return }
            checkedInProfiles[locationReference.recordID, default: []].append(profile)
        }
        
        //Runs when all records are done
        //The cursor holds the current position of the Query sinc cloudkit returns a limited Number of results
        operation.queryResultBlock = { result in
            switch result{
            case .success(let cursor):
                if let cursor = cursor{
                    print("1️⃣ First Cursor is not nil - \(cursor)")
                    print("👨‍👩‍👧‍👦 Current Dictionary - \(checkedInProfiles)")
                    self.continueWithCheckedInProfilesDict(
                        cursor: cursor,
                        dictionary: checkedInProfiles) { result in
                            switch result {
                            case .success(let profiles):
                                print("😊  Initial success - Dictionaray - \(profiles)")
                                completed(.success(profiles))
                            case .failure(let error):
                                print("❌  Initial Error")
                                completed(.failure(error))
                            }
                        }
                } else {
                    completed(.success(checkedInProfiles))
                }
            case .failure(let error):
                completed(.failure(error))
            }
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    //Handles code pagination via cursor
    func continueWithCheckedInProfilesDict(
        cursor: CKQueryOperation.Cursor,
        dictionary: [CKRecord.ID: [DDGProfile]],
        completed: @escaping(Result<[CKRecord.ID: [DDGProfile]], Error>)->Void
    ){
        var checkedInProfiles = dictionary
        let operation = CKQueryOperation(cursor: cursor)
        
        operation.recordFetchedBlock = { record in
            // Building the dictionary
            let profile = DDGProfile(record: record)
            guard let locationReference = record[DDGProfile.kIsCheckedIn]  as? CKRecord.Reference else { return }
            checkedInProfiles[locationReference.recordID, default: []].append(profile)
        }
        
        //Runs when all records are done
        //The cursor holds the current position of the Query sinc cloudkit returns a limited Number of results
        operation.queryResultBlock = { result in
            switch result{
            case .success(let cursor):
                if let cursor = cursor{
                    print("⭕️ Recursive Cursor is not nil - \(cursor)")
                    print("👨‍👩‍👧‍👦 Current Dictionary - \(checkedInProfiles)")
                    self.continueWithCheckedInProfilesDict(
                        cursor: cursor,
                        dictionary: checkedInProfiles) { result in
                            switch result {
                            case .success(let profiles):
                                print("😊 ⭕️ Recursive success - Dictionaray - \(profiles)")
                                completed(.success(profiles))
                            case .failure(let error):
                                print("❌ ⭕️ Recursive Errror")
                                completed(.failure(error))
                            }
                        }
                } else {
                    completed(.success(checkedInProfiles))
                }
                
            case .failure(let error):
                completed(.failure(error))
            }
        }
        CKContainer.default().publicCloudDatabase.add(operation)
        
    }
    
    
    //Get a dictionary of how many people are checked into a given lcation
    func getCheckedInProfilesCount(completed: @escaping(Result<[CKRecord.ID: Int], Error>)->Void){
        let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        //We can also filter the keys we want to get back
        operation.desiredKeys = [DDGProfile.kIsCheckedIn]
        var checkedInProfiles: [CKRecord.ID: Int] = [:]
        operation.recordFetchedBlock = { record in
            // Building the dictionary
            guard let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else { return }
            
            if let count = checkedInProfiles[locationReference.recordID] {
                checkedInProfiles[locationReference.recordID] = count + 1
            }else {
                checkedInProfiles[locationReference.recordID] = 1
            }
        }
        //Runs when all records are done
        //The cursor holds the current position of the Query sinc cloudkit returns a limited Number of results
        operation.queryResultBlock = { result in
            switch result{
            case .success(_):
                completed(.success(checkedInProfiles))
            case .failure(let error):
                completed(.failure(error))
            }
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    
    func batchSave(records: [CKRecord], completed: @escaping(Result<[CKRecord], Error>)->Void){
        //Create a CKOpertation to save our User and Profile Records
        let operation = CKModifyRecordsOperation(recordsToSave: records)
        operation.modifyRecordsCompletionBlock = { savedRecords, _, error in
            guard let savedRecords = savedRecords, error == nil else {
                print(error!.localizedDescription)
                completed(.failure(error!))
                return
            }
            completed(.success(savedRecords))
        }
        //Fires of Operation
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    
    func save(record: CKRecord, completed: @escaping (Result<CKRecord, Error>) -> Void){
        CKContainer.default().publicCloudDatabase.save(record){ record, error in
            guard let record = record, error == nil else {
                completed(.failure(error!))
                return
            }
            
            completed(.success(record))
        }
    }
    
    
    func fetchRecord(with id: CKRecord.ID, completed: @escaping(Result<CKRecord, Error>)->Void){
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: id) { record, error in
            guard let record = record, error == nil else {
                completed(.failure(error!))
                return
            }
            completed(.success(record))
        }
    }
}

