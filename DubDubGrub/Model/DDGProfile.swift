//
//  DDGProfile.swift
//  DubDubGrub
//
//  Created by Joel Storr on 20.09.23.
//

import CloudKit


struct DDGProfile{
    
    
    static let kFirstName = "firstName"
    static let kLastName = "lastName"
    static let kAvatar = "avatar"
    static let kCompanyName = "companyName"
    static let kBio = "bio"
    static let kIsCheckedIn = "isCheckedIn"

    
    let ckRecordID: CKRecord.ID
    
    let firstName: String
    let lastName: String
    let avatar: CKAsset!
    let companyName: String
    let bio: String
    var isCheckedIn: CKRecord.Reference? = nil
    
    
    
    init(record: CKRecord){
        ckRecordID = record.recordID
        
        firstName = record[DDGProfile.kFirstName] as? String ?? "N/A"
        lastName = record[DDGProfile.kLastName] as? String ?? "N/A"
        avatar = record[DDGProfile.kAvatar] as? CKAsset
        companyName = record[DDGProfile.kCompanyName] as? String ?? "N/A"
        bio = record[DDGProfile.kBio] as? String ?? "N/A"
       // isCheckedIn = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference ?? nil
        
    }
}
