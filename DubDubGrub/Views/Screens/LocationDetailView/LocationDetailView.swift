//
//  LocationDetailView.swift
//  DubDubGrub
//
//  Created by Joel Storr on 17.09.23.
//

import SwiftUI

struct LocationDetailView: View {
    
   
    @ObservedObject var viewModel: LocationDetailViewModel
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 16){
                BannerImageView(image: viewModel.location.bannerImage)
                AdressHStack(address: viewModel.location.address)
                DescriptionView(text: viewModel.location.description)
                
                    HStack(spacing: 20){
                        Button{
                            viewModel.getDirectionToLocation()
                        }label: {
                            LocationActionButton(color: .brandPrimary, imageName: "location.fill")
                        }
                        .accessibilityLabel(Text("Get directions"))
                        
                        Link(destination: URL(string: viewModel.location.websiteURL)!) {
                            
                            LocationActionButton(color: .brandPrimary, imageName: "network")
                        }
                        .accessibilityRemoveTraits(.isButton)
                        .accessibilityLabel(Text("Go to website"))
                        
                        Button{
                            viewModel.callLocation()
                        }label: {
                            LocationActionButton(color: .brandPrimary, imageName: "phone.fill")
                        }
                        .accessibilityLabel(Text("Call location"))
                        
                        if let _ = CloudKitManager.shared.profileRecordID {
                            Button{
                                viewModel.upadteCheckinStatus(to: viewModel.isCheckedIn ? .checkedOut : .checkedIn)
                            }label: {
                                LocationActionButton(
                                    color: viewModel.buttonColor,
                                    imageName: viewModel.buttonImageTitle
                                )
                                .accessibilityLabel(Text(viewModel.buttonA11yLabel))
                            }
                            .disabled(viewModel.isLoading)
                        }
                    }
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    .background(Color(.secondarySystemBackground))
                    .clipShape(Capsule())
                
                GridHeaderTextView(number: viewModel.checkedInProfiles.count)
                
                ZStack{
                    if viewModel.checkedInProfiles.isEmpty {
                        GridEmptyStateTextView()
                            
                    }else{
                        ScrollView{
                            LazyVGrid(columns: viewModel.determinColumns(for: dynamicTypeSize)) {
                                ForEach(viewModel.checkedInProfiles){ profile in
                                    FirstNameAvtarView(profile: profile)
                                        .onTapGesture {
                                            withAnimation{
                                                viewModel.show(profile, in: dynamicTypeSize)
                                            }
                                        }
                                }
                            }
                        }
                    }
                    if viewModel.isLoading { LoadingView() }
                }
                Spacer()
            }
            .accessibilityHidden(viewModel.isShowingProfileModal)
            if viewModel.isShowingProfileModal {
                FullScreenBlackTransparencyView()
                
                ProfileModalView(
                    profile: viewModel.selectedProfile!,
                    isShowingProfileModal: $viewModel.isShowingProfileModal
                )
                
            }
        }
        
        .task{
            viewModel.getCheckedInProfiles()
            viewModel.getCheckedInStatus()
        }
        .navigationTitle(viewModel.location.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.isShowingProfileSheet){
            NavigationStack{
                ProfileSheetView(profile: viewModel.selectedProfile!)
                    .toolbar{
                        Button("Dismiss"){
                            viewModel.isShowingProfileSheet = false
                        }
                    }
            }
        }
        .alert(item: $viewModel.alertItem, content: {$0.alert})
    }
}


struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LocationDetailView(
                viewModel: LocationDetailView.LocationDetailViewModel(
                    location: DDGLocation(record: MockData.chipotle)
                )
            ).embedInScrollView()
        }
    }
}


fileprivate struct LocationActionButton: View {
    
    var color: Color
    var imageName: String
    
    var body: some View {
        ZStack{
            Circle()
//                .fill(
//                    Color.brandPrimary
//                    .gradient
//                        .shadow(.inner(color: .black.opacity(0.2), radius: 5, x: 2, y: 2))
//                )
                //.foregroundColor(color)
                .frame(width: 60, height: 60)
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .foregroundStyle(
                    Color.white
                        .shadow(.drop(color: .black.opacity(0.5), radius: 3))
                )
                //.foregroundColor(.white)
                .frame(width: 22, height: 22)
        }
    }
}


fileprivate struct FirstNameAvtarView: View {
    
    var profile: DDGProfile
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    
    var body: some View{
        VStack{
            AvatarView(
                image: profile.avatarImage,
                size: dynamicTypeSize >= .accessibility3 ? 100 : 64
            )
            Text(profile.firstName)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(Text("Show's \(profile.firstName) profile pop up."))
        .accessibilityLabel(Text("\(profile.firstName) \(profile.lastName)"))
    }
}


fileprivate struct BannerImageView: View {
    
    var image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(height: 120)
            .accessibilityHidden(true)
    }
}


fileprivate struct AdressHStack: View {
    
    var address: String
    
    var body: some View {
        HStack{
            Label(address, systemImage: "mappin.and.ellipse")
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding(.horizontal)
    }
}


fileprivate struct DescriptionView: View {
    
    var text: String
    var body: some View {
        Text(text)
            .minimumScaleFactor(0.75)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal)
    }
}

fileprivate struct GridHeaderTextView: View {
    
    var number: Int
    
    var body: some View {
        Text("Who's Here?")
            .bold()
            .font(.title2)
            .accessibilityAddTraits(.isHeader)
            .accessibilityLabel("Who's Here? \(number) checked in")
            .accessibilityHint(Text("Bottom section is scrollable"))
    }
}


fileprivate struct GridEmptyStateTextView: View {
    
    var body: some View {
        Text("Nobody's Here 😔")
            .bold()
            .font(.title2)
            .foregroundColor(Color.secondary)
            .padding(.top, 30)
    }
}

fileprivate struct FullScreenBlackTransparencyView: View {
    
    var body: some View {
        Color(.black)
            .ignoresSafeArea()
            .opacity(0.9)
            .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.35)))
            //.transition(.opacity)
            //.animation(.easeOut)
            .zIndex(1)
            .accessibilityHidden(true)
    }
}
