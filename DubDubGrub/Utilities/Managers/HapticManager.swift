//
//  HapticManager.swift
//  DubDubGrub
//
//  Created by Joel Storr on 13.10.23.
//

import UIKit

struct HapticManager{
    static func playSuccess(){
//        let generator = UINotificationFeedbackGenerator()
//        generator.notificationOccurred(.success)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
}
