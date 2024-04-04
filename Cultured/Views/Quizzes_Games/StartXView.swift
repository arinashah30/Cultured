//
//  StartXView.swift
//  Cultured
//
//  Created by Shreyas Goyal on 4/4/24.
//

import SwiftUI

struct StartXView: View {
    @ObservedObject var vm: ViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var gameName: String
    @State var countryName: String
    @State var backgroundImage: Image
    @State var categories: [String]
    @State var categoryProgress: [Float]
    
    @State private var selectedCategory: String = ""
    let categoryColors = [Color("Category1"), Color("Category2"), Color("Category3"), Color("Category4")]
    let buttonColors: [Color] = [Color(red: 252/255, green: 179/255, blue: 179/255), Color(red: 255/255, green: 219/255, blue: 165/255), Color(red: 171/255, green: 232/255, blue: 186/255), Color(red: 153/255, green: 194/255, blue: 223/255)]
    
    let buttonWidth: CGFloat = 156
    let buttonHeight: CGFloat = 57
    
    private func selectCategory(category: String) {
        selectedCategory = category
        print("Selected Category " + selectedCategory)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack (alignment: .topLeading){
                    backgroundImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 400, height: 470, alignment: .top)
                    
                    
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        
                        ZStack {
                            Circle()
                                .frame(width: 50, height: 50)
                                .padding(.top, 150)
                                .padding(.leading, 20)
                                .foregroundColor(Color.white.opacity(0.8))
                            Image("Arrow")
                                .padding(.top, 150)
                                .padding(.leading, 18)
                        }
                        
                    }
                    
                }
                
                ZStack (alignment: .topLeading){
                    Rectangle()
                        .frame(width: 400, height: 460)
                        .clipShape(.rect(cornerRadius: 40))
                        .foregroundColor(.white)
                    VStack (alignment: .leading){
                        Text(gameName)
                            .foregroundColor(.cDarkGray)
                            .font(Font.custom("Quicksand-SemiBold", size: 32))
                        Text(countryName)
                            .foregroundColor(.cMedGray)
                        Text("Select Category")
                            .font(Font.custom("Quicksand-Medium", size: 20))
                            .foregroundColor(.cDarkGray)
                            .padding(.top, 20)
                        HStack(alignment: .center, spacing: 20) {
                            ProgressButtonView(buttonText: categories[0], buttonColor: categoryColors[0], progress: categoryProgress[0]) {
                                selectCategory(category: categories[0])
                            }
                            
                            ProgressButtonView(buttonText: categories[1], buttonColor: categoryColors[1], progress: categoryProgress[1]) {
                                selectCategory(category: categories[1])
                            }
                        }
                        
                        HStack(alignment: .center, spacing: 20) {
                            ProgressButtonView(buttonText: categories[2], buttonColor: Color("Category3"), progress: categoryProgress[2]) {
                                selectCategory(category: categories[2])
                            }
                            
                            ProgressButtonView(buttonText: categories[3], buttonColor: Color("Category4"), progress: categoryProgress[3]) {
                                selectCategory(category: categories[3])
                            }
                        }
                        
                        NavigationLink(destination: {
                            if (gameName == "Word Guessing") {
                                WordGuessingView(vm: WordGuessingViewModel())
                            } else if (gameName == "Quiz") {
                                QuestionView(vm: QuizViewModel())
                            } else if (gameName == "Connections") {
                                ConnectionsGameView(vm: ConnectionsViewModel())
                            }
                            
                        }, label: {
                            Text("Start")
                                .font(.system(size: 20))
                                .foregroundColor(.cDarkGray)
                                .padding()
                        })
                        .frame(maxWidth: 154, maxHeight: 57, alignment: .center)
                        .background(Color.black.opacity(0.1))
                        .clipShape(.rect(cornerRadius: 100.0))
                        .padding(.top, 15)
                        .padding(.leading, 85)
                        //.padding(.bottom, 200)
                    }
                    .padding(.top, 30)
                    .padding(.leading, 35)
                    //.frame(alignment: .center)
                }
            }
            .padding(.bottom, 200)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    StartXView(vm: ViewModel(), gameName: "Game Name", countryName: "Country", backgroundImage: Image("WordGuessing"), categories: ["Pop Culture", "Food", "Customs", "Places"], categoryProgress: [0.4, 0.7, 0.2, 1.0])
}
