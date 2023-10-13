//
//  ProfileModalView.swift
//  DubDubGrub
//
//  Created by Joel Storr on 29.09.23.
//

import SwiftUI

struct ProfileModalView: View {
    
    var profile: DDGProfile
    @Binding var isShowingProfileModal: Bool
    
    var body: some View {
        ZStack{
            VStack{
                Spacer().frame(height: 60)
                Text("\(profile.firstName) \(profile.lastName)")
                    .bold()
                    .font(.title2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .padding(.horizontal)
                Text(profile.companyName)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .foregroundColor(.secondary)
                    .accessibilityLabel(Text("Works at \(profile.companyName)"))
                    .padding(.horizontal)
                
                Text(profile.bio)
                    .lineLimit(3)
                    .padding()
                    .accessibilityLabel(Text("Bio, \(profile.bio)"))
                    
                    
            }
            .frame(width: 300, height: 230)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            .overlay(
                Button{
                    withAnimation{
                        isShowingProfileModal = false                        
                    }
                } label:{
                    XDismissButton()
                }, alignment: .topTrailing
            )
            Image(uiImage: profile.avatarImage)
                .resizable()
                .scaledToFit()
                .frame(width: 110, height: 110)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 6)
                .offset(y: -120)
                .accessibilityHidden(true)
        }
    }
}


#Preview {
    ProfileModalView(profile: DDGProfile(record: MockData.profile), isShowingProfileModal: .constant(true))
}
