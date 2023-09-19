//
//  Label+Ext.swift
//  DubDubGrub
//
//  Created by Joel Storr on 19.09.23.
//

import SwiftUI

struct RedBackgroundLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        Label(configuration)
            .padding(4)
            .background(Color.red)
            .foregroundColor(Color.white)
            .cornerRadius(3.0)
            .font(.system(size: 10, weight: .bold))
            
    }
}
