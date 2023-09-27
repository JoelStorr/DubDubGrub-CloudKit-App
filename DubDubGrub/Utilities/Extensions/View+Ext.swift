//
//  View+Ext.swift
//  DubDubGrub
//
//  Created by Joel Storr on 17.09.23.
//


import SwiftUI

extension View {
    
    func tabViewDefaultBackground() -> some View {
        self.onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    func profileNameStyle() -> some View{
        self.modifier(ProfileNameStyle())
    }
        
    func dismissKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}




