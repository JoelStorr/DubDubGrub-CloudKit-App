//
//  AppTabViewModel.swift
//  DubDubGrub
//
//  Created by Joel Storr on 08.10.23.
//


import SwiftUI


extension AppTabView{
    
    final class AppTabViewModel:  ObservableObject{
        
        @Published var isShowingOnboardview = false
        @AppStorage("hasSeenOnboardView") var hasSeenOnboardView = false {
            didSet {
                isShowingOnboardview = hasSeenOnboardView
            }
        }
        
        
        let kHasSeenTheOnboardView = "hasSeenOnboardView"
        
        
        func checkIfHasSeenOnboarding(){
            if !hasSeenOnboardView { hasSeenOnboardView = true }
        }
    }
}


