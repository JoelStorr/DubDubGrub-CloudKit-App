//
//  ProfileModalView.swift
//  DubDubGrub
//
//  Created by Joel Storr on 29.09.23.
//

import SwiftUI

struct ProfileModalView: View {
    
    
    var profile: DDGProfile
    
    var body: some View {
        ZStack{
            VStack{
                Spacer().frame(height: 60)
                Text("\(profile.firstName) \(profile.lastName)")
                    .bold()
                    .font(.title2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                Text(profile.companyName)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .foregroundColor(.secondary)
                
                Text(profile.bio)
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
            
            Image(uiImage: profile.createAvatarImage())
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
    ProfileModalView(profile: DDGProfile(record: MockData.profile))
}
