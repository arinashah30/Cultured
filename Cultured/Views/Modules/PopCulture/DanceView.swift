//
//  DanceView.swift
//  Cultured
//
//  Created by Rudra Amin on 3/30/24.
//

import SwiftUI

struct DanceView: View {
    @ObservedObject var vm: ViewModel
    @State var danceDict: [String:String] = [:]
    
    var body: some View {
        ZStack(){
            // the background image
            VStack{
                Image("Dance")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width:UIScreen.main.bounds.width, height: 2*UIScreen.main.bounds.width/3)
                    .offset(y:-UIScreen.main.bounds.width/2)
                //                .opacity(0.5)
            }
        
            
            VStack{
                
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color.cPopover)
                    .frame(width: UIScreen.main.bounds.width, height: 2*UIScreen.main.bounds.height / 3)
                    .offset(y: UIScreen.main.bounds.height / 7)
            }
            
            
            // the quiz
            
            VStack {
                VStack(alignment: .leading) {
                    Text("Dance")
                        .font(Font.custom("Quicksand-semibold",size: 32))
                        .foregroundColor(Color.cDarkOrange)
                  
                    Text(vm.get_current_country())
                        .font(.system(size: 16))
                        .foregroundColor(
                            Color(red: 157/255, green: 157/255, blue: 157/255))
                    
                    
                    
                    Text("Traditional")
                        .padding(.vertical, 10)
                        .font(Font.custom("Quicksand-medium",size: 24))
                    
                        ScrollView {
                            VStack (spacing: 20) {
                                ForEach(Array(danceDict.keys.sorted().enumerated()), id: \.element) { index, danceName in
                                    SingleDance(vm: vm, DanceName: danceName, DanceDescription: danceDict[danceName] ?? "", DanceImage: "\(vm.get_current_country().lowercased())_dance_\(index+1)");
                                }
                            }
                        }.padding(.bottom, 70)
                        .scrollIndicators(.hidden)
                }
            }.offset(y:UIScreen.main.bounds.height/4.5).padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
            
        }
        .onAppear {
            vm.getInfoDance(countryName: vm.get_current_country().uppercased()) { dance in
                danceDict = dance.danceDictionary
                print(dance.danceDictionary)
            }
        }
        .navigationBarBackButtonHidden()
        .padding(.bottom, 100)
        
    }
}


struct SingleDance: View {
    var vm: ViewModel
    var DanceName: String;
    var DanceDescription: String;
    var DanceImage: String;
    @State var uiImage: UIImage? = nil
    
    var body: some View {
        HStack (alignment: .top) {
            if let uiImage = uiImage {
                Image(uiImage: uiImage).resizable().aspectRatio(contentMode: .fit).clipShape(RoundedRectangle(cornerRadius: 14)).frame(width: 145)
            } else {
                // Placeholder image or loading indicator
                ProgressView()
                    .frame(width: 145, height: 185)
            }

            Spacer()
            VStack (alignment: .leading, spacing: 0) {
                Text(DanceName).font(Font.custom("Quicksand-medium",size: 24)).padding(.vertical, 10)
                Text(DanceDescription).font(Font.custom("Quicksand-regular",size: 20))
            }.padding(.trailing, 10)
                .foregroundColor(Color.cDarkGray)
        }.onAppear {
            vm.getImage(imageName: DanceImage) { image in
                uiImage = image
            }
        }.frame(width: 321, height: 185).background(Color("cBarColor")).clipShape(RoundedRectangle(cornerRadius: 14)).shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 3)
    }
}



#Preview {
    DanceView(vm: ViewModel())
}
