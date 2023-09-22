//
//  CKRecord+Ext.swift
//  DubDubGrub
//
//  Created by Joel Storr on 22.09.23.
//

import CloudKit



extension CKRecord{
    func convertToDDGLocation() -> DDGLocation{ DDGLocation(record: self) }
    func convertToDDGProfile() -> DDGProfile{ DDGProfile(record: self) }
}
