//
//  AvatarView.swift
//  DubDubGrub
//
//  Created by Joel Storr on 19.09.23.
//

import SwiftUI

struct AvatarView: View {
    
    var image: UIImage
    var size: CGFloat
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
}


#Preview {
    AvatarView( image: PlaceholderImage.avatar, size: 90)
}
