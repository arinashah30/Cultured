//
//  SelfProfileView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI
import MapKit
import PhotosUI

struct SelfProfileView: View {
    @ObservedObject var vm: ViewModel
    @State var showFullMap = false
    @State var completedCountries: [String] = []
    
    @State private var isPickerPresented = false
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: URL?
    
    init(avatarItem: PhotosPickerItem? = nil, vm: ViewModel, avatarImage: String? = nil) {
        self.vm = vm
        self.avatarImage = URL(string: avatarImage ?? "")
        print(avatarImage)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                //Settings bar
                HStack {
                    Spacer()
                    NavigationLink{
                        EditSelfProfileView(vm:vm)
                            .navigationBarBackButtonHidden(true)
                            .toolbar(.hidden, for: .tabBar)
                    } label: {
                        Image(systemName: "gear")
                            .resizable()
                            .frame(width: 38, height: 36)
                            .foregroundColor(.cMedGray)
                            .padding()
                    }
                }
                
                //Prof pic/placeholder with edit button
                VStack {
                    AsyncImage(url: avatarImage) { image in
                        image
                            .resizable()
                            .frame(width: 156, height: 156)
                            .background(Color(red:217/255, green: 217/255, blue: 217/255))
                            .background(Color.cLightGray)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(.circle)
                    }
                    PhotosPicker("Edit Profile Picture", selection: $avatarItem, matching: .images).foregroundColor(.blue).font(.system(size: 13))
                }
                .onChange(of: avatarItem) {
                    Task {
                        if let data = try? await avatarItem?.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                vm.updateProfilePic(userID: vm.current_user?.id ?? "", image: uiImage) { image in
                                    self.vm.current_user?.profilePicture = image.absoluteString
                                    avatarImage = image
                                    
                                }
                                return
                            }
                        }
                        print("Could not load transferable from selected item")
                    }
                }
                .onAppear {
                    print("avim : \(avatarImage)")
                    avatarImage = URL(string: vm.current_user?.profilePicture ?? "")
                }
                Spacer(minLength: 20)
                
                
                Text("\(vm.current_user?.name ?? "No Username")")
                    .font(Font.custom("Quicksand-Semibold", size: 32))
                    .foregroundColor(.cDarkGray)
                Text("\(vm.current_user?.id ?? "No id")")
                    .font(.system(size: 20))
                    .foregroundColor(.cMedGray)
                
                
                Text("My Challenges")
                    .font(Font.custom("Quicksand", size:24))
                    .foregroundColor(.cDarkGray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .padding([.top, .leading], 15)
                
                Button(action: {
                    self.showFullMap.toggle()
                }, label: {
                    MapView(vm: vm, showFullMap: $showFullMap, completedCountries: $completedCountries)
                        .frame(width:354 ,height: 175)
                        .cornerRadius(20)
                        .padding(.bottom, 10)
                })
                .fullScreenCover(isPresented: $showFullMap, content: {
                    MapView(vm: vm, showFullMap: $showFullMap, completedCountries: $completedCountries)
                })
                Spacer()
                ChallengeView(country: vm.current_user?.country ?? "Mexico", status: "In Progress")
                ForEach(completedCountries, id: \.self) { country in
                    ChallengeView(country: country, status: "Completed")
                }
                
                
            }
        }.onAppear {
            vm.getCompletedCountries(userID: vm.current_user?.id ?? "") { countries in
                completedCountries = countries
            }
        }
    }
}

struct ChallengeView: View {
    var country: String
    var status: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.cPopover)
                .frame(width:354, height: 68)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            HStack{
                Text(countryflags[country] ?? "🇲🇽")
                    .font(.system(size: 50))
                Text(country)
                    .font(.system(size: 20))
                    .foregroundColor(Color.cDarkGray)
                Spacer()
                ZStack{
                    Rectangle()
                        .foregroundColor(status == "Completed" ? Color.cGreen : Color.cOrange)
                        .frame(width: 110, height: 33)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Text(status)
                        .font(.system(size: 20))
                        .foregroundColor(Color.cDarkGrayConstant)
                }
            }
            .frame(width:330, height: 68)
        }
    }
}


#Preview {
    SelfProfileView(vm: ViewModel())
}
