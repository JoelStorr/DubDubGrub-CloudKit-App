//
//  LoadingView.swift
//  DubDubGrub
//
//  Created by Joel Storr on 28.09.23.
//

import SwiftUI

struct LoadingView: View {
    
    var body: some View {
        ZStack{
            Color(.systemBackground)
                .opacity(0.9)
                .ignoresSafeArea()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .brandPrimary))
                .scaleEffect(2)
                .offset(y: -40)
        }
    }
}

#Preview {
    LoadingView()
}
