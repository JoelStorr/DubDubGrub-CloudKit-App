//
//  CloudKitManager.swift
//  DubDubGrub
//
//  Created by Joel Storr on 21.09.23.
//

import CloudKit


struct CloudKitManager{
    
    
    static func getLocations(completed: @escaping (Result<[DDGLocation], Error>) -> Void) {
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
    
    
}

