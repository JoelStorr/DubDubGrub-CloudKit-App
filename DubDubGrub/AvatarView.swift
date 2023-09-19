//
//  AvatarView.swift
//  DubDubGrub
//
//  Created by Joel Storr on 19.09.23.
//

import SwiftUI

struct AvatarView: View {
    
    var size: CGFloat
    
    var body: some View {
        Image("default-avatar")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
}


#Preview {
    AvatarView(size: 90)
}
