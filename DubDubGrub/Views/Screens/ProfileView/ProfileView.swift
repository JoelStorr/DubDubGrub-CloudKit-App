//
//  ProfileView.swift
//  DubDubGrub
//
//  Created by Joel Storr on 16.09.23.
//

import SwiftUI
import CloudKit

struct ProfileView: View {
    
    
    @StateObject private var viewModel = ProfileViewModel()
    
    
    @State var charNumber: Int = 100
    @State var bioText: String = ""
    
    
    var body: some View {
        
        ZStack {
            VStack{
                //SECTION: Top Card
                ZStack{
                    NameBackgroundView()
                    
                    HStack(spacing: 16){
                        ZStack{
                            AvatarView(image: viewModel.avatar,size: 84)
                            EditImage()
                        }
                        .padding(.leading, 12)
                        .onTapGesture { viewModel.isShowingPhotoPicker = true }
                        VStack(spacing: 1){
                            TextField("First Name", text: $viewModel.firstName).profileNameStyle()
                            TextField("Last Name", text: $viewModel.lastName).profileNameStyle()
                            TextField("Company Name", text:$viewModel.companyName)
                        }
                        .padding(.trailing, 16)
                    }.padding()
                }
                
                //SECTION: BIO
                VStack(alignment: .leading, spacing: 8){
                    CharactersRemainView(currentCount: viewModel.bio.count)
                    TextEditor(text: $viewModel.bio)
                        .frame(height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke( Color.secondary, lineWidth: 1))
                    
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button {
                    viewModel.createProfile()
                } label: {
                    DDGButton(title: "Create Profile")
                }.padding(.bottom)
            }
            
            if viewModel.isLoading { LoadingView() }
        }
        .navigationTitle("Profile")
        .toolbar(content: {
            Button{
                dismissKeyboard()
            }label: {
                Image(systemName: "keyboard.chevron.compact.down")
            }
        })
        .onAppear{
            viewModel.getProfile()
        }
        .alert(item: $viewModel.alertItem, content: { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        })
        .sheet(isPresented: $viewModel.isShowingPhotoPicker){
            PhotoPicker(image: $viewModel.avatar)
        }
        
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