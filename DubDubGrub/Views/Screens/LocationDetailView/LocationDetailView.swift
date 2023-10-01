//
//  LocationDetailView.swift
//  DubDubGrub
//
//  Created by Joel Storr on 17.09.23.
//

import SwiftUI

struct LocationDetailView: View {
    
   
    @ObservedObject var viewModel: LocationDetailViewModel
    
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 16){
                BannerImageView(image: viewModel.location.createBannerImage())
                
                HStack{
                    AdrassView(address: viewModel.location.address)
                    Spacer()
                }
                .padding(.horizontal)
                DescriptionView(text: viewModel.location.description)
                
                
                ZStack{
                    Capsule()
                        .frame(height: 80)
                        .foregroundColor(Color(.secondarySystemBackground))
                    HStack(spacing: 20){
                        Button{
                            viewModel.getDirectionToLocation()
                        }label: {
                            LocationActionButton(color: .brandPrimary, imageName: "location.fill")
                        }
                        
                        Link(destination: URL(string: viewModel.location.websiteURL)!) {
                            
                            LocationActionButton(color: .brandPrimary, imageName: "network")
                        }
                        
                        Button{
                            viewModel.callLocation()
                        }label: {
                            LocationActionButton(color: .brandPrimary, imageName: "phone.fill")
                        }
                        Button{
                            viewModel.upadteCheckinStatus(to: .checkedOut)
                        }label: {
                            LocationActionButton(color: .brandPrimary, imageName: "person.fill.checkmark")
                        }
                    }
                    
                }
                
                Text("Who's Here?")
                    .bold()
                    .font(.title2)
                
                ScrollView{
                    LazyVGrid(columns: viewModel.columns) {
                        FirstNameAvtarView(image: PlaceholderImage.avatar, firstName: "Sean")
                            .onTapGesture {
                                viewModel.isSHowingProfileModal = true
                            }
                       
                    }
                }
                
                
                
                Spacer()
                
            }
            
            if viewModel.isSHowingProfileModal {
                Color(.systemBackground)
                    .ignoresSafeArea()
                    .opacity(0.9)
                    //.transition(.opacity)
                    .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.35)))
                    //.animation(.easeOut)
                    .zIndex(1)
                
                ProfileModalView(
                    profile: DDGProfile(record: MockData.profile),
                    isShowingProfileModal: $viewModel.isSHowingProfileModal
                )
                .transition(.opacity.combined(with: .slide))
                .animation(.easeOut)
                .zIndex(2)
            }
        }
        .navigationTitle(viewModel.location.name)
        .navigationBarTitleDisplayMode(.inline)
        .alert(item: $viewModel.alertItem, content: { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        })
    }
}


struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LocationDetailView(
                viewModel: LocationDetailViewModel(
                    location: DDGLocation(
                        record: MockData.location
                    )
                )
            )
        }
    }
}

struct LocationActionButton: View {
    
    var color: Color
    var imageName: String
    
    var body: some View {
        ZStack{
            Circle()
                .foregroundColor(color)
                .frame(width: 60, height: 60)
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 22, height: 22)
            
        }
    }
}

struct FirstNameAvtarView: View {
    
    var image: UIImage
    var firstName: String
    
    var body: some View{
        VStack{
            AvatarView(image: image, size: 64)
            Text(firstName)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
    }
    
}

struct BannerImageView: View {
    
    var image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(height: 120)
    }
}

struct AdrassView: View {
    
    var address: String
    
    var body: some View {
        Label(address, systemImage: "mappin.and.ellipse")
            .font(.caption)
            .foregroundColor(.secondary)
    }
}

struct DescriptionView: View {
    
    var text: String
    var body: some View {
        Text(text)
            .lineLimit(3)
            .minimumScaleFactor(0.75)
            .frame(height: 70)
            .padding(.horizontal)
    }
}
