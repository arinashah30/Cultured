//
//  CountrySetView.swift
//  Cultured
//
//  Created by Ryan O’Meara on 4/12/24.
//

import SwiftUI

struct CountrySetView: View {
    @ObservedObject var vm: ViewModel
    @State private var selectedOption: String?
    @Environment(\.dismiss) private var dismiss
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    public var selectedGray: Color {
        Color(red:240/255, green:240/255, blue:240/255)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack{
                    Image("SignInBanner")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: screenWidth, height: screenHeight / 4)
                        .padding(.top, -8)
                    Image("CulturedTitle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:screenWidth * 2/3, height: screenHeight / 1/5)
                    
                }
                
                Text("Select Destination")
                    .font(Font.custom("Quicksand-Medium", size: 32))
                    .foregroundColor(.cDarkGray)
                    .padding(.top, 25)
                Text("Choose a country to learn about")
                    .font(.system(size: 16))
                    .foregroundColor(.cMedGray)
                    .padding(.bottom, 20)
                
                
                Button {
                    selectedOption = "France"
                } label: {
                    if(selectedOption == "France") {
                        HStack {
                            Text("France 🇫🇷")
                                .font(Font.custom("Quicksand-Medium", size: 24))
                                .foregroundStyle(Color.cDarkGray)
                            
                        }
                        .frame(width: screenWidth * 3/4, height: screenHeight * 1/17)
                        .background(selectedGray)
                        .cornerRadius(12)
                        .padding(.top, -8)
                    } else {
                        HStack {
                            Text("France 🇫🇷")
                                .font(Font.custom("Quicksand-Medium", size: 24))
                                .foregroundStyle(Color.cDarkGray)
                            
                        }
                        .frame(width: screenWidth * 3/4, height: screenHeight * 1/17)
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.top, -8)
                    }
                }

                Divider()
                    .frame(width: screenWidth * 3/4, height: 2)
                    .overlay(selectedGray)
                    .padding([.top, .bottom], -5)
                
                Button {
                    selectedOption = "India"
                } label: {
                    if(selectedOption == "India") {
                        HStack {
                            Text("India 🇮🇳")
                                .font(Font.custom("Quicksand-Medium", size: 24))
                                .foregroundStyle(Color.cDarkGray)
                            
                        }
                        .frame(width: screenWidth * 3/4, height: screenHeight * 1/17)
                        .background(selectedGray)
                        .cornerRadius(12)
                        .padding(.top, -8)
                    } else {
                        HStack {
                            Text("India 🇮🇳")
                                .font(Font.custom("Quicksand-Medium", size: 24))
                                .foregroundStyle(Color.cDarkGray)
                            
                        }
                        .frame(width: screenWidth * 3/4, height: screenHeight * 1/17)
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.top, -8)
                    }
                }

                Divider()
                    .frame(width: screenWidth * 3/4, height: 2)
                    .overlay(selectedGray)
                    .padding([.top, .bottom], -5)
                
                Button {
                    selectedOption = "Mexico"
                } label: {
                    if(selectedOption == "Mexico") {
                        HStack {
                            Text("Mexico 🇲🇽")
                                .font(Font.custom("Quicksand-Medium", size: 24))
                                .foregroundStyle(Color.cDarkGray)
                            
                        }
                        .frame(width: screenWidth * 3/4, height: screenHeight * 1/17)
                        .background(selectedGray)
                        .cornerRadius(12)
                        .padding(.top, -8)
                    } else {
                        HStack {
                            Text("Mexico 🇲🇽")
                                .font(Font.custom("Quicksand-Medium", size: 24))
                                .foregroundStyle(Color.cDarkGray)
                            
                        }
                        .frame(width: screenWidth * 3/4, height: screenHeight * 1/17)
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.top, -8)
                    }
                }

                Divider()
                    .frame(width: screenWidth * 3/4, height: 2)
                    .overlay(selectedGray)
                    .padding([.top, .bottom], -5)
                
                Button {
                    selectedOption = "UAE"
                } label: {
                    if(selectedOption == "UAE") {
                        HStack {
                            Text("United Arab Emirates 🇦🇪")
                                .font(Font.custom("Quicksand-Medium", size: 24))
                                .foregroundStyle(Color.cDarkGray)
                            
                        }
                        .frame(width: screenWidth * 3/4, height: screenHeight * 1/17)
                        .background(selectedGray)
                        .cornerRadius(12)
                        .padding(.top, -8)
                    } else {
                        HStack {
                            Text("United Arab Emirates 🇦🇪")
                                .font(Font.custom("Quicksand-Medium", size: 24))
                                .foregroundStyle(Color.cDarkGray)
                            
                        }
                        .frame(width: screenWidth * 3/4, height: screenHeight * 1/17)
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.top, -8)
                    }
                }

                Divider()
                    .frame(width: screenWidth * 3/4, height: 2)
                    .overlay(selectedGray)
                    .padding([.top, .bottom], -5)
                
                Button {
                    selectedOption = "Italy"
                } label: {
                    if(selectedOption == "Italy") {
                        HStack {
                            Text("Italy 🇮🇹")
                                .font(Font.custom("Quicksand-Medium", size: 24))
                                .foregroundStyle(Color.cDarkGray)
                            
                        }
                        .frame(width: screenWidth * 3/4, height: screenHeight * 1/17)
                        .background(selectedGray)
                        .cornerRadius(12)
                        .padding(.top, -8)
                    } else {
                        HStack {
                            Text("Italy 🇮🇹")
                                .font(Font.custom("Quicksand-Medium", size: 24))
                                .foregroundStyle(Color.cDarkGray)
                            
                        }
                        .frame(width: screenWidth * 3/4, height: screenHeight * 1/17)
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.top, -8)
                    }
                }
                
            Button {
                vm.setCurrentCountry(userID: vm.current_user!.id, countryName: selectedOption ?? "Mexico", completion: {_ in})
            } label: {
                if (selectedOption == nil) {
                    Text("Start Learning")
                        .foregroundColor(.black)
                        .font(.system(size: 19))
                        .frame(width: screenWidth * 7/8, height: screenHeight * 1/13)
                        .background(Color.cOrange)
                        .clipShape(.rect(cornerRadius: 60))
                        .opacity(0.5)
                } else {
                    Text("Start Learning")
                        .foregroundColor(.black)
                        .font(.system(size: 19))
                        .frame(width: screenWidth * 7/8, height: screenHeight * 1/13)
                        .background(Color.cOrange)
                        .clipShape(.rect(cornerRadius: 60))
                }
            }
            .padding()
            .disabled(selectedOption == nil)
                
                Spacer()
                
            }
            .ignoresSafeArea()
        }
    }
//    private enum CountryOption: Hashable {
//        case France
//        case Mexico
//        case Italy
//        case UAE
//        case India
//    }
}


#Preview {
    CountrySetView(vm: ViewModel())
}
