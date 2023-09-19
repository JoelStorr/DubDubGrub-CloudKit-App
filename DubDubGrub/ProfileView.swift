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
                    Color(.secondarySystemBackground)
                        .frame(height: 130)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    
                    HStack(spacing: 16){
                        ZStack{
                            AvatarView(size: 84)
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                                .foregroundColor(.white)
                                .offset(y:30)
                        }
                        .padding(.leading, 12)
                        //TODO: Add Tap gesture on image
                        VStack(spacing: 1){
                            TextField("First Name", text: $firstName)
                                .font(.system(size: 32, weight: .bold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                            
                            TextField("Last Name", text: $lastName)
                                .font(.system(size: 32, weight: .bold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                            
                            TextField("Company Name", text:$companyName)
                                
                            
                        }
                        .padding(.trailing, 16)
                    }.padding()
                    
                }
                
                //SECTION: BIO
                VStack(alignment: .leading, spacing: 8){
                    Text("Bio: ")
                        .font(.callout)
                        .foregroundColor(.secondary)
                    +
                    Text("\(100 - bio.count)")
                        .bold()
                        .font(.callout)
                        .foregroundColor(bio.count <= 100 ? .brandPrimary : Color(.systemPink))
                    +
                    Text(" Characters remain")
                        .font(.callout)
                        .foregroundColor(Color.secondary)
                    TextEditor(text: $bio)
                        .frame(height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke( Color.secondary, lineWidth: 1))
                    
                }
                .padding(.horizontal, 20)
                
                Spacer()
                    
                Button {
                    return
                } label: {
                    Text("Create Profile")
                        .bold()
                        .frame(width: 280, height: 44)
                        .background(Color.brandPrimary)
                        .foregroundColor(.white)
                        .cornerRadius(8)
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
