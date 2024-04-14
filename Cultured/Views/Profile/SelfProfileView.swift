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
            VStack {
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
//                    VStack {
//                       Spacer()
//                       HStack {
//                           Spacer()
//                           Button {
//                               isPickerPresented.toggle()
//                               print(isPickerPresented)
//                           } label: {
//                               Circle()
//                                   .fill(Color.cMedGray)
//                                   .frame(width: 44, height: 45)
//                                   .overlay(
//                                       Image(systemName: "pencil")
//                                           .resizable()
//                                           .aspectRatio(contentMode: .fit)
//                                           .foregroundColor(.white)
//                                           .padding(10)
//                                   )
////                                   .offset(x: -115, y: -33)//this is hardcoded couldnt figure out a better way to do it
//                           }
//                           
//                       }
//                        if isPickerPresented {
//                            PhotosPicker("Edit Profile Picture", selection: $avatarItem, matching: .images)
//                        }
//                    }
                }
                .onChange(of: avatarItem) {
                    Task {
                        if let data = try? await avatarItem?.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                vm.updateProfilePic(userID: vm.current_user?.id ?? "", image: uiImage) { image in
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
                    avatarImage = URL(string: vm.current_user!.profilePicture)
                }
                Spacer()
                
                VStack{
                    Text("\(vm.current_user?.name ?? "")")
                        .font(Font.custom("Quicksand-Semibold", size: 32))
                        .foregroundColor(.cDarkGray)
                    
                    Text("\(vm.current_user?.id ?? "")")
                        .font(.system(size: 20))
                        .foregroundColor(.cMedGray)
                        .padding()
                }
            }
            
            //Prof pic/placeholder with edit button
            ZStack{
                Image("BlankUser")
                    .resizable()
                    .frame(width: 156, height: 156)
                    .background(Color.cLightGray)
                    .clipShape(Circle())
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Circle()
                            .fill(Color.cMedGray)
                            .frame(width: 44, height: 45)
                            .overlay(
                                Image(systemName: "pencil")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.white)
                                    .padding(10)
                            )
                            .offset(x: -115, y: -33)//this is hardcoded couldnt figure out a better way to do it
                    }
                }
            }
            VStack{
                Text("\(vm.current_user?.name ?? "No user")")
                    .font(Font.custom("Quicksand-Semibold", size: 32))
                    .foregroundColor(.cDarkGray)
                
                Text("\(vm.current_user?.id ?? "No user")")
                    .font(.system(size: 20))
                    .foregroundColor(.cMedGray)
            }
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
            
            
            
        }.onAppear {
            vm.getCompletedCountries(userID: vm.current_user?.id ?? "") { countries in
                completedCountries = countries
            }
        }
    }
    
//        init(vm: ViewModel, showFullMap: Bool = false) {
//            self.vm = vm
//            self.showFullMap = showFullMap
//            self.completedCountries = []
//            var donecountries: [String] = []
//            self.vm.getCompletedCountries(userID: vm.current_user?.id ?? "") { countries in
//                donecountries = countries
//                print("DONE COUNTRIES \(donecountries)")
//            }
//            self.completedCountries = donecountries
//            print("COMPLETEDCOUNTRIES: \(completedCountries)")
//        }
}

struct ChallengeView: View {
    var country: String
    var status: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.cLightGray)
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
                        .fill(Color.cOrange)
                        .frame(width: 110, height: 33)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Text(status)
                        .font(.system(size: 20))
                        .foregroundColor(Color.cDarkGray)
                }
            }
            .frame(width:330, height: 68)
        }
    }
}


#Preview {
    SelfProfileView(vm: ViewModel())
}
