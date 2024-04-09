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
    @State var categoryProgress: [Float] = [0.0, 0.0, 0.0, 0.0]
    
    @State private var navigate: Bool = false
    //@State private var category2Active: Bool = false
    //@State private var category3Active: Bool = false
    //@State private var category4Active: Bool = false
    
    @State private var selectedCategory: String = ""
    let categoryColors = [Color("Category1"), Color("Category2"), Color("Category3"), Color("Category4")]
    let buttonColors: [Color] = [Color(red: 252/255, green: 179/255, blue: 179/255), Color(red: 255/255, green: 219/255, blue: 165/255), Color(red: 171/255, green: 232/255, blue: 186/255), Color(red: 153/255, green: 194/255, blue: 223/255)]
    
    let buttonWidth: CGFloat = 156
    let buttonHeight: CGFloat = 57
    
    private func selectCategory(category: Int) -> some View {
        if gameName == "WordGuessing" {
            return AnyView(WordGuessingView(vm: vm.wordGuessingViewModel!))
        } else if gameName == "Quiz" {
            return AnyView(QuestionView(vm: vm.quizViewModel!))
        } else {
            return AnyView(ConnectionsGameView(vm: vm.connectionsViewModel!))
        }
    }
    
    private func setupActivity(category: Int) {
        if gameName == "WordGuessing" {
            vm.wordGuessingViewModel!.current_word_guessing_game = vm.wordGuessingViewModel!.word_guessings["\(vm.current_user!.country)\(categories[category])WordGuessing"]
            navigate = true
        } else if gameName == "Quiz" {
            vm.quizViewModel!.current_quiz = vm.quizViewModel!.quizzes["\(vm.current_user!.country)\(categories[category])Quiz"]
            navigate = true
        } else if gameName == "Connections" {
            vm.connectionsViewModel!.current_connections_game = vm.connectionsViewModel!.connections["\(vm.current_user!.country)\(categories[category])Connections"]
            navigate = true
        }
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
                            Button {
                                setupActivity(category: 0)
                            } label: {
                                ProgressButtonView(buttonText: categories[0], buttonColor: Color("Category1"), progress: categoryProgress[0])
                            }.navigationDestination(isPresented: $navigate) { selectCategory(category: 0)}
                            
                            Button {
                                setupActivity(category: 1)
                            } label: {
                                ProgressButtonView(buttonText: categories[1], buttonColor: Color("Category2"), progress: categoryProgress[1])
                            }.navigationDestination(isPresented: $navigate) { selectCategory(category: 1)}
                        }
                        
                        HStack(alignment: .center, spacing: 20) {
                            Button {
                                setupActivity(category: 2)
                            } label: {
                                ProgressButtonView(buttonText: categories[2], buttonColor: Color("Category3"), progress: categoryProgress[2])
                            }.navigationDestination(isPresented: $navigate) { selectCategory(category: 2)}
                            
                            Button {
                                setupActivity(category: 3)
                            } label: {
                                ProgressButtonView(buttonText: categories[3], buttonColor: Color("Category4"), progress: categoryProgress[3])
                            }.navigationDestination(isPresented: $navigate) { selectCategory(category: 3)}
                        }
                        
//                        NavigationLink(destination: {
//                            if (gameName == "Word Guessing") {
//                                vm.wordGuessingViewModel?.current_word_guessing_game = 
//                                WordGuessingView(vm: vm.wordGuessingViewModel!)
//                            } else if (gameName == "Quiz") {
//                                QuestionView(vm: vm.quizViewModel!)
//                            } else if (gameName == "Connections") {
//                                ConnectionsGameView(vm: vm.connectionsViewModel!)
//                            }
//                            
//                        }, label: {
//                            Text("Start")
//                                .font(.system(size: 20))
//                                .foregroundColor(.cDarkGray)
//                                .padding()
//                        })
//                        .frame(maxWidth: 154, maxHeight: 57, alignment: .center)
//                        .background(Color.black.opacity(0.1))
//                        .clipShape(.rect(cornerRadius: 100.0))
//                        .padding(.top, 15)
//                        .padding(.leading, 85)
//                        //.padding(.bottom, 200)
                    }
                    .padding(.top, 30)
                    .padding(.leading, 35)
                    //.frame(alignment: .center)
                }
            }
            .padding(.bottom, 200)
            .onAppear() {
                if gameName == "WordGuessing" {
                    
                } else if gameName == "Quiz" {
                    categoryProgress = vm.quizViewModel!.getProgress()
                } else if gameName == "Connections" {
        
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    StartXView(vm: ViewModel(), gameName: "Game Name", countryName: "Country", backgroundImage: Image("WordGuessing"), categories: ["Pop Culture", "Food", "Customs", "Places"], categoryProgress: [0.4, 0.7, 0.2, 1.0])
}
