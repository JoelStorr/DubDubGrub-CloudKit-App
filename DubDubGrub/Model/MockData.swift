//
//  MockData.swift
//  DubDubGrub
//
//  Created by Joel Storr on 20.09.23.
//

import CloudKit

struct MockData{
    
    static var location: CKRecord{
        let record = CKRecord(recordType: RecordType.location)
        record[DDGLocation.kName] = "Sean's Barn and Grill"
        record[DDGLocation.kAdress] = "123 Main Street"
        record[DDGLocation.kDescription] = "This is a test description. Isn't it awsome. Not sure how long to make it to thest the 3 lines"
        record[DDGLocation.kWebsiteURL] = "https://www.apple.com"
        record[DDGLocation.kLocation] = CLLocation(latitude: 37.331516, longitude: -121.891054)
        record[DDGLocation.kPhoneNumber] = "111-111-1111"
        return record
    }
    
    
    static var profile: CKRecord{
        let record = CKRecord(recordType: RecordType.profile)
        record[DDGProfile.kFirstName] = "Test"
        record[DDGProfile.kLastName] = "User"
        record[DDGProfile.kCompanyName] = "Best Company ever"
        record[DDGProfile.kBio] = "This is my Bio, I hope it is not to long because I can't check character count."
        return record
    }
}
