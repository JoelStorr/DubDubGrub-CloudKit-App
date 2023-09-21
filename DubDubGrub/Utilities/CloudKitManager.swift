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
        let sortDescriptor = NSSortDescriptor(key: DDGLocation.kName, ascending: true)
        
        
        
        //Uses Convinience API
        //Query: return all DDGLocations
        let query = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
    }
    
    
}

