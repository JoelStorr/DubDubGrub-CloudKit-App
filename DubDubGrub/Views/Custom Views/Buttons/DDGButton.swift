//
//  DGButton.swift
//  DubDubGrub
//
//  Created by Joel Storr on 19.09.23.
//

import SwiftUI

struct DDGButton: View {
    
    var title: String
    var color: Color = .brandPrimary
    
    var body: some View {
        Text(title)
            .bold()
            .frame(width: 280, height: 44)
            .background(color.gradient)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

#Preview {
    DDGButton(title: "Test Button")
}
