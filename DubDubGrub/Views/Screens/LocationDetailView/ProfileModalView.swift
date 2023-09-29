//
//  ProfileModalView.swift
//  DubDubGrub
//
//  Created by Joel Storr on 29.09.23.
//

import SwiftUI

struct ProfileModalView: View {
    var body: some View {
        ZStack{
            VStack{
                Spacer().frame(height: 60)
                Text("Sean Allen")
                    .bold()
                    .font(.title2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                Text("Demo Company")
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .foregroundColor(.secondary)
                
                Text("This is my samply Bio to see how long we can make this and how does the padding works untill it runs out of space and breaks of the text")
                    .lineLimit(3)
                    .padding()
                    
                    
            }
            .frame(width: 300, height: 230)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            .overlay(
                Button{
                    //TODO: Add dismis function
                } label:{
                    XDismissButton()
                }, alignment: .topTrailing
            )
            
            Image(uiImage: PlaceholderImage.avatar)
                .resizable()
                .scaledToFit()
                .frame(width: 110, height: 110)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 6)
                .offset(y: -120)
        }
    }
}

#Preview {
    ProfileModalView()
}
