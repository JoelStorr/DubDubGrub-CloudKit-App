//
//  UIImage+Ext.swift
//  DubDubGrub
//
//  Created by Joel Storr on 27.09.23.
//


import CloudKit
import UIKit

extension UIImage {
    
    func convertToCKAsset() -> CKAsset?{
        //Get apps bsed document directory url
        guard let urlPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Document directory came back nil")
            return nil
        }
        //Append some unique identifier for our profile image
        let fileUrl = urlPath.appendingPathComponent("selectedAvatarImage")
        
        //Write the image data to the location the adress points to
        guard let imageData = jpegData(compressionQuality: 0.25) else {
            print("Could not compress image")
            return nil
        }
        
        //Create CKAsset with file url
        do{
            try imageData.write(to: fileUrl)
            return CKAsset(fileURL: fileUrl)
        }catch{
            print("Could not write the image")
            return nil
        }
    }
}

