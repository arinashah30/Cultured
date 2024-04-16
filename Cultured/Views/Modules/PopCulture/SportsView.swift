//
//  SportsView.swift
//  Cultured
//
//  Created by Ryan O’Meara on 4/15/24.
//

import SwiftUI

struct SportsView: View {
    @ObservedObject var vm: ViewModel
    @State var athletes: [String] = [ "Hugo Sánchez","Saúl \"Canelo\" Álvarez", "Lorena Ochoa", "Joaquín Capilla Pérez ​", "Marie-José Pérec"]
    @State var sports: [String: String] = ["Bullfighting":"Many people in Mexico enjoy watching bullfighting. The largest bullring in the world is located in Mexico City.", "Charreria":"Similar to rodeo, Mexico’s national sport, charrería, is a traditional equestrian series of events involving riding horses and bulls and roping.", "Fútbol":"Mexico’s most famous sport is fútbol, or soccer, a fast-paced, active game where players kick a ball into a goal."]
    @State var sport: Sports = Sports()
    
    var body: some View {
        ZStack(alignment: .topLeading){
            
            VStack{
                ZStack(alignment: .topLeading){
                    Image("Sports")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    BackButton()
                    //                        .offset(x:80, y:20)
                }
                .frame(width:screenWidth,height:screenHeight * 0.4)
                .ignoresSafeArea()
            }
                                
            VStack(alignment:.leading){
                
                Text("Sports")
                    .font(Font.custom("Quicksand-Bold", size: 32))
                    .foregroundColor(Color(red:25/255, green:176/255, blue:62/255))
                    .padding(.top, 30)
                    .padding(.leading, 30)
                
                Text(vm.get_current_country())
                //                        Text("Mexico")
                    .font(Font.custom("Quicksand-Light", size: 15))
                    .padding(.bottom, 15)
                    .padding(.leading, 30)
                
                Text("Athlete Spotlight")
                    .font(Font.custom("Quicksand-Medium", size:24))
                    .padding(.leading, 30)
                
                ScrollView(.horizontal) {
                    HStack{
                        ForEach(Array(athletes.enumerated()), id: \.element) { index, athleteName in
                            AthleteCard(vm:vm, athleteName: athleteName,athleteImage: "\(vm.get_current_country().lowercased())_athlete_\(index+1)");
                            
                        }
                    }
                }
                .scrollIndicators(.hidden)
                
                Text("Popular")
                    .font(Font.custom("Quicksand-Regular", size: 24))
                    .padding(.leading, 30)
                    .padding(.bottom, 15)
                HStack{
                    Spacer()
                    TabView{
                        ForEach(Array(sports.keys.sorted().enumerated()), id: \.element) { index, sportName in
                            SportCard(vm: vm, SportName: sportName, SportDescription: sports[sportName] ?? "", SportImage: "\(vm.get_current_country().lowercased())_sports_\(index+1)");
                            
                        }
                        
                    }
                    .frame(width: screenWidth * 0.8, height: screenHeight * 0.23)
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                    
                    .background(Color("cBarColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 3)
                    Spacer()
                }
            }
                .frame(width: screenWidth, height: screenHeight)
                .background(Color.cPopover)
                .clipShape(.rect(cornerRadius: 50))
                .offset(y:screenHeight * 0.25)
        }
        
        .onAppear {
            vm.getInfoSports(countryName: vm.get_current_country()) {sport in
                sports = sport.sports
                athletes = sport.athletes
                print("SELF SPORTS \(self.sport)")
            }
        }
        
    }
}

struct SportCard: View {
    var vm: ViewModel
    var SportName: String;
    var SportDescription: String;
    var SportImage: String;
    @State var uiImage: UIImage? = nil
    
    
    var body: some View {
        HStack (alignment: .top) {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenWidth * 0.3, height: screenHeight * 0.23)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            } else {
                // Placeholder image or loading indicator
                ProgressView()
                    .frame(width: 145, height: 185)
            }

//            Spacer()
            VStack (alignment: .leading, spacing: 0) {
                Text(SportName).font(Font.custom("Quicksand-medium",size: 24)).padding(.vertical, 10)
                Text(SportDescription).font(Font.custom("Quicksand-regular",size: 20))
                    .lineLimit(5)
            }
            .padding(.trailing, 10)
                .foregroundColor(Color.cDarkGray)
        }
        .frame(width:screenWidth * 0.8, height:screenHeight * 0.2)
        .onAppear {
            vm.getImage(imageName: SportImage) { image in
                uiImage = image
            }
        }
    }
}

struct AthleteCard: View {
    var vm: ViewModel
    var athleteName: String
    var athleteImage: String
    @State var uiImage: UIImage? = nil
    var body: some View {
        VStack {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screenHeight * 0.15, height: screenHeight * 0.15)
                    .clipped()
                    .clipShape(.circle)
            } else {
                // Placeholder image or loading indicator
                ProgressView()
                    .frame(width: 145, height: 185)
            }
            
            Text("\(athleteName)")
                .multilineTextAlignment(.center)
                .foregroundColor(Color.cDarkGray)
            
            
            
        }
        .frame(width:screenWidth * 0.2, height:screenHeight * 0.20)
        .onAppear {
            vm.getImage(imageName: athleteImage) { image in
                uiImage = image
            }
        }
    }
}

#Preview {
    SportsView(vm: ViewModel())
}
