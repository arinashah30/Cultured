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
        DynamicNavigationView(vm: vm, gameName: gameName)
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
                        .foregroundColor(.white)
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
                                let progressBinding = Binding<Float>(
                                        get: { self.categoryProgress[0] },
                                        set: { self.categoryProgress[0] = $0 }
                                    )
                                ProgressButtonView(buttonText: categories[0], buttonColor: Color("Category1"), progress: progressBinding)
                            }.navigationDestination(isPresented: $navigate) { selectCategory(category: 0)}
                            
                            Button {
                                setupActivity(category: 1)
                            } label: {
                                let progressBinding = Binding<Float>(
                                        get: { self.categoryProgress[1] },
                                        set: { self.categoryProgress[1] = $0 }
                                    )
                                ProgressButtonView(buttonText: categories[1], buttonColor: Color("Category2"), progress: $categoryProgress[1])
                            }.navigationDestination(isPresented: $navigate) { selectCategory(category: 1)}
                        }
                        
                        HStack(alignment: .center, spacing: 20) {
                            Button {
                                setupActivity(category: 2)
                            } label: {
                                let progressBinding = Binding<Float>(
                                        get: { self.categoryProgress[2] },
                                        set: { self.categoryProgress[2] = $0 }
                                    )
                                ProgressButtonView(buttonText: categories[2], buttonColor: Color("Category3"), progress: $categoryProgress[2])
                            }.navigationDestination(isPresented: $navigate) { selectCategory(category: 2)}
                            
                            Button {
                                setupActivity(category: 3)
                            } label: {
                                let progressBinding = Binding<Float>(
                                        get: { self.categoryProgress[3] },
                                        set: { self.categoryProgress[3] = $0 }
                                    )
                                ProgressButtonView(buttonText: categories[3], buttonColor: Color("Category4"), progress: $categoryProgress[3])
                            }.navigationDestination(isPresented: $navigate) { selectCategory(category: 3)}
                        }
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
                    categoryProgress = vm.connectionsViewModel!.getProgress()
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    StartXView(vm: ViewModel(), gameName: "Game Name", countryName: "Country", backgroundImage: Image("WordGuessing"), categories: ["Pop Culture", "Food", "Customs", "Places"], categoryProgress: [0.4, 0.7, 0.2, 1.0])
}
