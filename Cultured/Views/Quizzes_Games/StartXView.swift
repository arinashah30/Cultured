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
    let buttonColors: [Color] = [Color.cRed, Color.cOrange, Color.cGreen, Color.cBlue]
    
    let buttonWidth: CGFloat = 156
    let buttonHeight: CGFloat = 57
    
    private func selectCategory(category: Int) -> some View {
        DynamicNavigationView(vm: vm, gameName: gameName)
//        if gameName == "WordGuessing" {
//            return AnyView(WordGuessingView(vm: vm.wordGuessingViewModel!))
//        } else if gameName == "Quiz" {
//            //print("CURRENT QUIZ \(vm.quizViewModel!.current_quiz)")
//            if vm.$quizViewModel?.$current_quiz.completed {
//                return AnyView(QuestionView(vm: vm.quizViewModel!))
//            } else {
//                if vm.quizViewModel!.current_quiz!.completed {
//                    return AnyView(ResultsView(vm: vm.quizViewModel!))
//                } else {
//                    return AnyView(QuestionView(vm: vm.quizViewModel!))
//                }
//            }
//        } else {
//            return AnyView(ConnectionsGameView(vm: vm.connectionsViewModel!))
//        }
    }
    
    private func setupActivity(category: Int) {
        if gameName == "WordGuessing" {
            vm.wordGuessingViewModel!.start_wordguessing(category: categories[category].replacingOccurrences(of: "Pop ", with: "")) {
                navigate = true
            }
        } else if gameName == "Quiz" {
            vm.quizViewModel!.start_quiz(category: categories[category].replacingOccurrences(of: "Pop ", with: "")) {
                navigate = true
            }
        } else if gameName == "Connections" {
            vm.connectionsViewModel!.start_connections(category: categories[category].replacingOccurrences(of: "Pop ", with: "")) {
                navigate = true
            }
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
                        .foregroundColor(.cPopover)
                    VStack (alignment: .leading){
                        Text(gameName)
                            .foregroundColor(.cDarkGray)
                            .font(Font.custom("Quicksand-SemiBold", size: 32))
                        Text(vm.get_current_country())
                            .foregroundColor(.cMedGray)
                        Text("Select Category")
                            .font(Font.custom("Quicksand-Medium", size: 20))
                            .foregroundColor(.cDarkGray)
                            .padding(.top, 20)
                        HStack(alignment: .center, spacing: 20) {
                            Button {
                                setupActivity(category: 0)
                            } label: {
                                ProgressButtonView(buttonText: categories[0], buttonColor: buttonColors[0], progress: categoryProgress[0])
                            }.navigationDestination(isPresented: $navigate) { selectCategory(category: 0)}
                            
                            Button {
                                setupActivity(category: 1)
                            } label: {
                                ProgressButtonView(buttonText: categories[1], buttonColor: buttonColors[1], progress: categoryProgress[1])
                            }.navigationDestination(isPresented: $navigate) { selectCategory(category: 1)}
                        }
                        
                        HStack(alignment: .center, spacing: 20) {
                            Button {
                                setupActivity(category: 2)
                            } label: {
                                ProgressButtonView(buttonText: categories[2], buttonColor: buttonColors[2], progress: categoryProgress[2])
                            }.navigationDestination(isPresented: $navigate) { selectCategory(category: 2)}
                            
                            Button {
                                setupActivity(category: 3)
                            } label: {
                                ProgressButtonView(buttonText: categories[3], buttonColor: buttonColors[3], progress: categoryProgress[3])
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
                    categoryProgress = vm.wordGuessingViewModel!.getProgress()
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
