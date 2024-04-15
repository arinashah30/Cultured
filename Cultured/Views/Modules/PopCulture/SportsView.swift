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
    
    var body: some View {
        ZStack{
            
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
                
                
                Spacer()
                    .frame(height:screenHeight * 0.7)
                
            }
            
            VStack{
                
                Spacer()
                    .frame(height:screenHeight * 0.5)
                
                ScrollView(.vertical) {
                    
                    VStack(alignment:.leading){
                        
                        Text("Sports")
                            .frame(maxWidth:350, alignment: .leading)
                            .font(Font.custom("Quicksand-Bold", size: 32))
                            .foregroundColor(Color(red:25/255, green:176/255, blue:62/255))
                            .padding(.top, 30)
                            .padding(.leading, 30)
                        
//                        Text(vm.get_current_country())
                          Text("Mexico")
//                            .frame(maxWidth:325, alignment: .leading)
                            .font(Font.custom("Quicksand-Light", size: 15))
                            .padding(.bottom, 15)
                            .padding(.leading, 30)
                        
                        Text("Athlete Spotlight")
                            .font(Font.custom("Quicksand-Medium", size:24))
//                            .frame(maxWidth:350, alignment: .leading)
                            .padding(.leading, 30)
                        
                        ScrollView(.horizontal) {
                            LazyHStack {
                                ForEach(1..<athletes.count, id: \.self) {i in
                                    VStack {
//                                        Image()
//                                        .clipShape(.circle)
                                        
                                        Text("\(athletes[i])")
                                            .multilineTextAlignment(.center)
                                            
                                    }
                                    .frame(width: screenWidth / 4)
                                }
                                .scrollIndicators(.hidden)
                            }
                            .scrollIndicators(.hidden)
                        }
                        .scrollIndicators(.hidden)
                        .padding(.horizontal, 30)
                        .frame(height: 110)
                        
                        Text("Trending Songs")
                            .font(Font.custom("Quicksand-Regular", size: 24))
                            .padding(.leading, 30)

                        }
                        
                    }
                    
                .frame(width: screenWidth, height: screenHeight)
                    .background(Color.cPopover)
                    .clipShape(.rect(cornerRadius: 50))
                    
                }
                
            }
            // TODO: add dark mode? (this fix works for both light & dark modes)
            //.foregroundStyle(.black)
            
        }
    }

#Preview {
    SportsView(vm: ViewModel())
}
