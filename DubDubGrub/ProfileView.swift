//
//  ProfileView.swift
//  DubDubGrub
//
//  Created by Joel Storr on 16.09.23.
//

import SwiftUI

struct ProfileView: View {
    
    @State var charNumber: Int = 100
    @State var bioText: String = ""
    
    var body: some View {
        NavigationView {
            VStack{
                HStack{
                    Image("default-avatar")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                        .clipShape(Circle())
                    VStack{
                        Text("First Name")
                            .font(.headline)
                            .bold()
                        Text("Last Name")
                            .font(.headline)
                            .bold()
                        Text("Job Description")
                            .font(.caption)
                        
                    }
                    Spacer()
                }
                .background(Color(.secondarySystemBackground))
                
                HStack{
                    Text("Bio: \(charNumber) characters remain ")
                    Spacer()
                    Button() {
                        return
                    } label: {
                        Label("Check Out", systemImage: "mappin.and.ellipse")
                            .labelStyle(RedBackgroundLabelStyle())
                            
                            
                    }

                }
                .padding()
                
                TextField("Your Bio text", text: $bioText)
                    .frame(width: .infinity ,height: 100)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                    .padding(10)
                Spacer()
                Button("Save Profile") {
                    return
                }
            }
            .navigationTitle("Profile")
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
