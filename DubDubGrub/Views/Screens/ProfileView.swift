//
//  ProfileView.swift
//  DubDubGrub
//
//  Created by Joel Storr on 16.09.23.
//

import SwiftUI

struct ProfileView: View {
    
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var companyName = ""
    @State private var bio = ""
    
    @State var charNumber: Int = 100
    @State var bioText: String = ""
    
    var body: some View {
        
            VStack{
                
                //SECTION: Top Card
                ZStack{
                    NameBackgroundView()
                    
                    HStack(spacing: 16){
                        ZStack{
                            AvatarView(size: 84)
                            EditImage()
                        }
                        .padding(.leading, 12)
                        //TODO: Add Tap gesture on image
                        VStack(spacing: 1){
                            TextField("First Name", text: $firstName)
                                .profileNameStyle()
                            
                            TextField("Last Name", text: $lastName)
                                .profileNameStyle()
                            
                            TextField("Company Name", text:$companyName)
                                
                            
                        }
                        .padding(.trailing, 16)
                    }.padding()
                    
                }
                
                //SECTION: BIO
                VStack(alignment: .leading, spacing: 8){
                    CharactersRemainView(currentCount: bio.count)
                    TextEditor(text: $bio)
                        .frame(height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke( Color.secondary, lineWidth: 1))
                    
                }
                .padding(.horizontal, 20)
                
                Spacer()
                    
                Button {
                    return
                } label: {
                    DDGButton(title: "Create Profile")
                }

           
            }
            .navigationTitle("Profile")
            
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ProfileView()
        }
    }
}


struct NameBackgroundView: View {
    var body: some View {
        Color(.secondarySystemBackground)
            .frame(height: 130)
            .cornerRadius(12)
            .padding(.horizontal)
    }
}


struct EditImage: View {
    var body: some View {
        Image(systemName: "square.and.pencil")
            .resizable()
            .scaledToFit()
            .frame(width: 14, height: 14)
            .foregroundColor(.white)
            .offset(y:30)
    }
}

struct CharactersRemainView: View {
    
    var currentCount: Int
    
    var body: some View {
        Text("Bio: ")
            .font(.callout)
            .foregroundColor(.secondary)
        +
        Text("\(100 - currentCount)")
            .bold()
            .font(.callout)
            .foregroundColor(currentCount <= 100 ? .brandPrimary : Color(.systemPink))
        +
        Text(" Characters remain")
            .font(.callout)
            .foregroundColor(Color.secondary)
    }
}