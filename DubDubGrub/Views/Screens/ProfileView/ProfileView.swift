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
    
    @FocusState private var focusedTextField : ProfileTextField?
    
    enum ProfileTextField{ case firstName, lastName, companyName, bio }
    
    
    @State var charNumber: Int = 100
    @State var bioText: String = ""
    
    var body: some View {
        ZStack {
            VStack{
                //SECTION: Top Card
                HStack(spacing: 16){
                   ProfileImageView(image: viewModel.avatar)
                    .onTapGesture { viewModel.isShowingPhotoPicker = true }
                    
                    VStack(spacing: 1){
                        TextField("First Name", text: $viewModel.firstName)
                            .profileNameStyle()
                            .focused($focusedTextField, equals: .firstName)
                            .onSubmit{focusedTextField = .lastName}
                            .submitLabel(.next)
                        
                        TextField("Last Name", text: $viewModel.lastName)
                            .profileNameStyle()
                            .focused($focusedTextField, equals: .lastName)
                            .onSubmit{focusedTextField = .companyName}
                            .submitLabel(.next)
                        
                        TextField("Company Name", text:$viewModel.companyName)
                            .focused($focusedTextField, equals: .companyName)
                            .onSubmit{focusedTextField = .bio}
                            .submitLabel(.next)
                    }
                    .padding(.trailing, 16)
                }
                .padding(.vertical)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                
                
                //SECTION: BIO
                VStack(alignment: .leading, spacing: 8){
                    HStack{
                        CharactersRemainView(currentCount: viewModel.bio.count)
                            .accessibilityAddTraits(.isHeader)
                        Spacer()
                        if viewModel.isCheckedIn {
                            Button{
                                HapticManager.playSuccess()
                                viewModel.checkout()
                            } label: {
                                CheckOutButton()
                            }
                            .disabled(viewModel.isLoading)
                        }
                    }
                    TextField("Enter your bio", text: $viewModel.bio, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(4...6)
                        .focused($focusedTextField, equals: .bio)
                        .accessibilityHint(Text("This text field is for your bio and has a 100 character maximum."))
                    
//                    BioTextEditor(text: $viewModel.bio)
//                        .focused($focusedTextField, equals: .bio)
                        
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button {
                    viewModel.determineButtonAction()
                } label: {
                    DDGButton(title: viewModel.buttonTitle)
                }.padding(.bottom)
            }
            .toolbar{
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Dismiss"){ focusedTextField = nil}
                }
            }
            
            if viewModel.isLoading { LoadingView() }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(DeviceTypes.isiPhone8Standard ? .inline : .automatic)
        .ignoresSafeArea(.keyboard)
        .task{
            viewModel.getProfile()
            viewModel.getCheckedInStatus()
        }
        .alert(item: $viewModel.alertItem, content: {$0.alert})
        .sheet(isPresented: $viewModel.isShowingPhotoPicker){
            PhotoPicker(image: $viewModel.avatar)
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            ProfileView()
        }
    }
}


fileprivate struct NameBackgroundView: View {
    var body: some View {
        Color(.secondarySystemBackground)
            .frame(height: 130)
            .cornerRadius(12)
            .padding(.horizontal)
    }
}


fileprivate struct ProfileImageView: View {
    
    var image: UIImage
    
    var body: some View {
        ZStack{
            AvatarView(image: image,size: 84)
            Image(systemName: "square.and.pencil")
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)
                .foregroundColor(.white)
                .offset(y:30)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel(Text("Profile Photo"))
        .accessibilityHint(Text("Opens the iPhone's photo picker"))
        .padding(.leading, 12)
       
        
        
    }
}


fileprivate struct CharactersRemainView: View {
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

struct CheckOutButton: View {
    var body: some View {
        Label("Check Out", systemImage: "mappin.and.ellipse")
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.white)
            .padding(10)
            .frame(height: 28)
            .background(Color.grubRed)
            .cornerRadius(3)
            .accessibilityLabel(Text("Check out of current location."))
    }
}

struct BioTextEditor: View {
    
    var text: Binding<String>
    
    var body: some View {
        TextEditor(text: text)
            .frame(height: 100)
            .overlay{ RoundedRectangle(cornerRadius: 8).stroke( Color.secondary, lineWidth: 1) }
            .accessibilityHint(Text("This text field is for your bio and has a 100 character maximum."))
    }
}
