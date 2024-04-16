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
    @State var backgroundImage: Image? = nil
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
                    if let backgroundImage = backgroundImage {
                        backgroundImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.47, alignment: .topLeading)
                    } else {
                        ProgressView()
                            .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.47, alignment: .top)
                    }
                    
                    //                }
                    BackButton()
                        .position(x:UIScreen.main.bounds.size.width/10, y:UIScreen.main.bounds.size.height/3.6)
                    //                        .offset(x:UIScreen.main.bounds.size.width/100, y:UIScreen.main.bounds.size.height/4.6)
                    
                    
                    ZStack (){
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.7, alignment: .bottom)
                            .clipShape(RoundedRectangle(cornerRadius: 40))
                            .foregroundColor(.cPopover)
                        VStack (alignment: .leading){
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
                            }
                            .padding(.leading, 0.06 * UIScreen.main.bounds.size.width)
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
                            .frame(maxWidth: .infinity, alignment: .center)
                            
                            HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.05) {
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
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding(.top, 30)
                        //                    .padding(.leading, 35)
                        .frame(alignment: .center)
                    }
                    .offset(y: UIScreen.main.bounds.size.height * 0.3)
                }
                .padding(.bottom, 200)
                .onAppear() {
                    vm.getImage(imageName: "\(vm.get_current_country().lowercased())_\(gameName.lowercased())") { image in
                        backgroundImage = Image(uiImage:image!)
                    }
                    
                    if gameName == "WordGuessing" {
                        categoryProgress = vm.wordGuessingViewModel!.getProgress()
                    } else if gameName == "Quiz" {
                        categoryProgress = vm.quizViewModel!.getProgress()
                    } else if gameName == "Connections" {
                        categoryProgress = vm.connectionsViewModel!.getProgress()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

//#Preview {
//    StartXView(vm: ViewModel(), gameName: "Game Name", countryName: "Country", backgroundImage: Image("WordGuessing"), categories: ["Pop Culture", "Food", "Customs", "Places"], categoryProgress: [0.4, 0.7, 0.2, 1.0])
//}
