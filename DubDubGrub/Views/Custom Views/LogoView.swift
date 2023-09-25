//
//  LogoView.swift
//  DubDubGrub
//
//  Created by Joel Storr on 25.09.23.
//

import SwiftUI

struct LogoView : View {
    
    var frameWidth: CGFloat
    
    var body: some View {
        Image("ddg-map-logo")
            .resizable()
            .scaledToFit()
            .frame(width: frameWidth)
    }
}

#Preview {
    LogoView(frameWidth: 250)
}
