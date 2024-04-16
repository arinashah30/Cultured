//
//  ChangeCountryView.swift
//  Cultured
//
//  Created by Ryan O’Meara on 4/12/24.
//

import SwiftUI

struct ChangeCountryView: View {
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    @ObservedObject var vm: ViewModel
    @State private var selectedOption: String?
    @Binding var popUpOpen: Bool
    @State private var isLoading = false
    

    public var buttonRed: Color {
        Color(red:247/255, green:64/255, blue:64/255)
    }
    
    public var selectedGray: Color {
        .cDarkGray
        //Color(red:240/255, green:240/255, blue:240/255)
    }
    
    var body: some View {
        ZStack (alignment:.top){
            VStack{
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
                
                Text("Choose Destination")
                    .font(Font.custom("Quicksand-Bold", size: 26))
                    .foregroundColor(.cDarkGray)
                    .padding(30)
                
                Button {
                    selectedOption = "France"
                } label: {
                    if(selectedOption == "France") {
                        HStack {
                            Text("France 🇫🇷")
                                .font(Font.custom("Quicksand-Medium", size: 24))
                                .foregroundStyle(Color.cDarkGrayReverse)
                            
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
                        .background(Color.cBar)
                        .cornerRadius(12)
                        .padding(.top, -8)
                    }
                }

                Divider()
                    .frame(width: screenWidth * 3/4, height: 2)
                    .overlay(.cDarkGray)
                    .padding([.top, .bottom], -5)
                
                Button {
                    selectedOption = "India"
                } label: {
                    if(selectedOption == "India") {
                        HStack {
                            Text("India 🇮🇳")
                                .font(Font.custom("Quicksand-Medium", size: 24))
                                .foregroundStyle(Color.cDarkGrayReverse)
                            
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
                        .background(Color.cBar)
                        .cornerRadius(12)
                        .padding(.top, -8)
                    }
                }

                Divider()
                    .frame(width: screenWidth * 3/4, height: 2)
                    .overlay(.cDarkGray)
                    .padding([.top, .bottom], -5)
                
                Button {
                    selectedOption = "Mexico"
                } label: {
                    if(selectedOption == "Mexico") {
                        HStack {
                            Text("Mexico 🇲🇽")
                                .font(Font.custom("Quicksand-Medium", size: 24))
                                .foregroundStyle(Color.cDarkGrayReverse)
                            
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
                        .background(Color.cBar)
                        .cornerRadius(12)
                        .padding(.top, -8)
                    }
                }

                Divider()
                    .frame(width: screenWidth * 3/4, height: 2)
                    .overlay(.cDarkGray)
                    .padding([.top, .bottom], -5)
                
                Button {
                    selectedOption = "United Arab Emirates"
                } label: {
                    if(selectedOption == "United Arab Emirates") {
                        HStack {
                            Text("United Arab Emirates 🇦🇪")
                                .font(Font.custom("Quicksand-Medium", size: 24))
                                .foregroundStyle(Color.cDarkGrayReverse)
                            
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
                        .background(Color.cBar)
                        .cornerRadius(12)
                        .padding(.top, -8)
                    }
                }

                Divider()
                    .frame(width: screenWidth * 3/4, height: 2)
                    .overlay(.cDarkGray)
                    .padding([.top, .bottom], -5)
                
                Button {
                    selectedOption = "Italy"
                } label: {
                    if(selectedOption == "Italy") {
                        HStack {
                            Text("Italy 🇮🇹")
                                .font(Font.custom("Quicksand-Medium", size: 24))
                                .foregroundStyle(Color.cDarkGrayReverse)
                            
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
                        .background(Color.cBar)
                        .cornerRadius(12)
                        .padding(.top, -8)
                    }
                
                }
                
                HStack {
                    Button {
                        popUpOpen = false
                    } label: {
                        Text("Back")
                            .font(.system(size: 20))
                            .bold()
                            .foregroundStyle(buttonRed)
                            .frame(width: screenWidth * 1/4 ,height: screenHeight * 1/17)
  
                            .overlay(
                            RoundedRectangle(cornerRadius: 100)
                            .inset(by: 1)
                            .stroke(buttonRed, lineWidth: 2)
                            )
                            
                    }
                    .opacity(isLoading ? 0 : 1)
                    
                    Button {
                        vm.setCurrentCountry(userID: vm.current_user!.id, countryName: selectedOption?.replacingOccurrences(of: "United Arab Emirates", with: "UnitedStates") ?? "Mexico", completion: {_ in})
                        isLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            // Set dataFetchComplete to true after 3 seconds
                            isLoading = false
                            popUpOpen = false
                        }
                        
                    } label: {
                        if selectedOption != nil {
                            Text("Start Learning")
                                .font(.system(size: 20))
                                .bold()
                                .foregroundStyle(buttonRed)
                                .frame(width: screenWidth * 2/5 ,height: screenHeight * 1/17)
      
                                .overlay(
                                RoundedRectangle(cornerRadius: 100)
                                .inset(by: 1)
                                .stroke(buttonRed, lineWidth: 2)
                                )
                                .padding(.leading, 10)
                        } else {
                            Text("Start Learning")
                                .font(.system(size: 20))
                                .bold()
                                .foregroundStyle(Color.cMedGray)
                                .frame(width: screenWidth * 2/5 ,height: screenHeight * 1/17)
      
                                .overlay(
                                RoundedRectangle(cornerRadius: 100)
                                .inset(by: 1)
                                .stroke(Color.cMedGray, lineWidth: 2)
                                )
                                .padding(.leading, 10)
                        }
                    }
                    .disabled(selectedOption == nil)
                    .opacity(isLoading ? 0 : 1)
                    
                }
                .padding([.top, .bottom], 20)
                Spacer()
            }
        }
        .frame(width: screenWidth, height: screenHeight * 0.75)
        .background(.cPopover)
        .cornerRadius(40.0)
        .offset(y:screenHeight * 0.75/2 - 100)
    }
}

#Preview {
    ChangeCountryView(vm: ViewModel(), popUpOpen: .constant(true))
}
