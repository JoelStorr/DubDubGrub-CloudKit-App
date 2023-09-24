//
//  CKAsset+Ext.swift
//  DubDubGrub
//
//  Created by Joel Storr on 24.09.23.
//

import CloudKit
import UIKit

extension CKAsset {
    func convertToUIImage(in dimension: ImageDimension) -> UIImage {
        let placeholder = ImageDimension.getPlaceholder(for: dimension)
        
        guard let fileUrl = self.fileURL else { return placeholder }
        
        do {
            let data = try Data(contentsOf: fileUrl)
            
            return UIImage(data: data) ?? placeholder
            
            
        }catch{
            return placeholder
        }
        
        
    }
}
