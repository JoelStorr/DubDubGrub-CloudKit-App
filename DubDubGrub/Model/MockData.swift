//
//  MockData.swift
//  DubDubGrub
//
//  Created by Joel Storr on 20.09.23.
//

import CloudKit


struct MockData{
    static var location: CKRecord{
        let record = CKRecord(recordType: "DDGLocation")
        record[DDGLocation.kName] = "Sean's Barn and Grill"
        record[DDGLocation.kAdress] = "123 Main Street"
        record[DDGLocation.kDescription] = "This is a test description. Isn't it awsome. Not sure how long to make it to thest the 3 lines"
        record[DDGLocation.kWebsiteURL] = "https://www.apple.com"
        record[DDGLocation.kLocation] = CLLocation(latitude: 37.331516, longitude: -121.891054)
        record[DDGLocation.kPhoneNumber] = "111-111-1111"
        
        
        
        return record
    }
}
