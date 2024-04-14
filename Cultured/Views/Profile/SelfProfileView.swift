//
//  SelfProfileView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI
import MapKit

struct SelfProfileView: View {
    @ObservedObject var vm: ViewModel
    @State var showFullMap = false
    @State var completedCountries: [String] = []
    
    var body: some View {
        VStack {
            //Settings bar
            HStack {
                Spacer()
                NavigationLink(destination: EditSelfProfileView(vm: vm)) {
                    Image(systemName: "gear")
                        .resizable()
                        .frame(width: 38, height: 36)
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
