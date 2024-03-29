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
    
    var body: some View {
        VStack {
            //Settings bar
            HStack {
                Spacer()
                Image(systemName: "gear")
                    .resizable()
                    .frame(width: 38, height: 36)
                    .foregroundColor(.cMedGray)
                    .padding()
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
                Text("First Last")
                    .font(Font.custom("Quicksand-Semibold", size: 32))
                    .foregroundColor(.cDarkGray)
                
                Text("username")
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
                MapView(locations: [
                    Location(name: "Mexico", coordinate: CLLocationCoordinate2D(latitude: 19.432608, longitude: -99.133209), flag: UIImage(imageLiteralResourceName: "MXFlag")),
                    Location(name: "France", coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522), flag: UIImage(imageLiteralResourceName: "USFlag"))
                ], showFullMap: $showFullMap)
                .frame(width:354 ,height: 175)
                    .cornerRadius(20)
                    .padding(.bottom, 10)
            })
            .fullScreenCover(isPresented: $showFullMap, content: {
                MapView(locations: [
                    Location(name: "Mexico", coordinate: CLLocationCoordinate2D(latitude: 19.432608, longitude: -99.133209), flag: UIImage(imageLiteralResourceName: "MXFlag")),
                    Location(name: "France", coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522), flag: UIImage(imageLiteralResourceName: "USFlag"))
                ], showFullMap: $showFullMap)
            })
            Spacer()
            //My Challenges
            ZStack {
                Rectangle()
                    .fill(Color.cLightGray)
                    .frame(width:354, height: 68)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                HStack{
                    Image("MXFlag")
                        .resizable()
                        .frame(width: 51.4, height: 39.8)
                    Text("Mexico")
                        .font(.system(size: 20))
                        .foregroundColor(Color.cDarkGray)
                    Spacer()
                    ZStack{
                        Rectangle()
                            .fill(Color.cOrange)
                            .frame(width: 110, height: 33)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        Text("In Progress")
                            .font(.system(size: 20))
                            .foregroundColor(Color.cDarkGray)
                    }
                }
                .frame(width:330, height: 68)
                
            }
            // Second Challenges
            ZStack {
                Rectangle()
                    .fill(Color.cLightGray)
                    .frame(width:354, height: 68)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                HStack{
                    Image("USFlag")
                        .resizable()
                        .frame(width: 51.4, height: 39.8)
                    Text("United States")
                        .font(.system(size: 20))
                        .foregroundColor(Color.cDarkGray)
                    Spacer()
                    ZStack{
                        Rectangle()
                            .fill(Color.cOrange)
                            .frame(width: 110, height: 33)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        Text("In Progress")
                            .font(.system(size: 20))
                            .foregroundColor(Color.cDarkGray)
                    }
                }
                .frame(width:330, height: 68)
                
            }
        }
    }
}

#Preview {
    SelfProfileView(vm: ViewModel())
}
