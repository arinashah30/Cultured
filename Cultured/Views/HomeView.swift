//
//  HomeView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var vm: ViewModel
    @State var points: Int = 0
    @State var streak: Int = 0
    @State var badges: Int = 0
    @State var popUpOpen: Bool = false
    @State var quizImage: UIImage? = nil
    @State var connectionsImage: UIImage? = nil
    @State var artourImage: UIImage? = nil
    @State var popCultureImage: UIImage? = nil
    @State var foodImage: UIImage? = nil
    @State var customsImage: UIImage? = nil
    @State var placesImage: UIImage? = nil

    
    var body: some View {
        NavigationStack {
            ZStack {
            
            VStack(alignment: .leading) {
                HStack { //Badges
                    Spacer()
                    Image("StarBadge")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .padding([.leading, .trailing], 1)
                    Text("\(points)")
                        .font(.system(size: 16))
                        .padding(.leading, -5)
                        .padding(.trailing, 1)
                    Image("FireBadge")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .padding([.leading, .trailing], 1)
                    Text("\(streak)")
                        .font(.system(size: 16))
                        .padding(.leading, -5)
                        .padding(.trailing, 1)
                    Image("ShieldBadge")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding([.leading, .trailing], 1)
                    Text("\(badges)")
                        .font(.system(size: 16))
                        .padding(.leading, -5)
                        .padding(.trailing, 20)
                }
                .padding(.top, 10)
                
                
                Text("Welcome to \(vm.get_current_country())")
                    .font(Font.custom("Quicksand-Semibold", size: 32))
                    .foregroundColor(.cDarkGray)
                    .padding(.leading, 10)
                
                Button {
                    popUpOpen = true
                } label: {
                    Text("Change Destination")
                        .font(.system(size: 16))
                        .foregroundColor(.cMedGray)
                        .padding(.bottom, 5)
                        .padding(.leading, 10)
                }
                Text("Learn")
                    .font(Font.custom("Quicksand-Medium", size: 24))
                    .foregroundColor(.cDarkGray)
                    .padding(.bottom, -5)
                    .padding(.leading, 10)
                
                ScrollView(.horizontal) {
                    HStack {
                        Spacer(minLength: 10)
                        
                        ZStack{
                            if let quizImage = quizImage {
                                Image(uiImage: quizImage)
                                    .resizable()
                                    .frame(width: 125, height: 125)
                            } else {
                                // Placeholder image or loading indicator
                                ProgressView()
                                    .frame(width: 125, height: 125)
                            }
                            Text("Quiz")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .bold()
                                .offset(y:-15)
                            NavigationLink {
                                StartQuizView(vm: vm, countryName: vm.current_user?.country ?? "Mexico", backgroundImage: Image("StartQuizImage"))
                            } label: {
                                Text("Start")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.black)
                                    .padding()
                            }
                            .frame(maxWidth: 80, maxHeight: 30)
                            .background(.white)
                            .clipShape(.rect(cornerRadius: 14.0))
                            .offset(y:20)
                        }
                        .clipShape(.rect(cornerRadius: 14.0))
                        .padding(.trailing, 8)
                        
                        
                        ZStack{
                            if let connectionsImage = connectionsImage {
                                Image(uiImage: connectionsImage)
                                    .resizable()
                                    .frame(width: 170, height: 125)
                            } else {
                                // Placeholder image or loading indicator
                                ProgressView()
                                    .frame(width: 170, height: 125)
                            }
                            Text("Connections")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .bold()
                                .offset(y:-15)
                            NavigationLink {
                                StartConnectionsView(vm: vm, countryName: vm.current_user?.country ?? "", backgroundImage: Image("WordGuessing"))
                            } label: {
                                Text("Start")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.black)
                                    .padding()
                            }
                            .frame(maxWidth: 80, maxHeight: 30)
                            .background(.white)
                            .clipShape(.rect(cornerRadius: 14.0))
                            .offset(y:20)
                        }
                        .clipShape(.rect(cornerRadius: 14.0))
                        .padding(.trailing, 8)
                        
                        ZStack{
                            if let connectionsImage = connectionsImage {
                                Image(uiImage: connectionsImage)
                                    .resizable()
                                    .frame(width: 170, height: 125)
                            } else {
                                // Placeholder image or loading indicator
                                ProgressView()
                                    .frame(width: 170, height: 125)
                            }
                            Text("Word Guessing")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .bold()
                                .offset(y:-15)
                            NavigationLink {
                                StartWordGuessingView(vm: vm, countryName: vm.current_user?.country ?? "", backgroundImage: Image("WordGuessing"))
                            } label: {
                                Text("Start")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.black)
                                    .padding()
                            }
                            .frame(maxWidth: 80, maxHeight: 30)
                            .background(.white)
                            .clipShape(.rect(cornerRadius: 14.0))
                            .offset(y:20)
                        }
                        .clipShape(.rect(cornerRadius: 14.0))
                        .padding(.trailing, 8)
                        
                        Spacer(minLength: 10)
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.bottom, 8)
                
                Text("Take a Tour")
                    .font(Font.custom("Quicksand-Medium", size: 24))
                    .foregroundColor(.cDarkGray)
                    .padding(.bottom, -5)
                    .padding(.leading, 10)
                
                HStack {
                    Spacer()
                    ZStack{
                        if let artourImage = artourImage {
                            Image(uiImage: artourImage)
                                .resizable()
                                .frame(width: 360, height: 135)
                        } else {
                            // Placeholder image or loading indicator
                            ProgressView()
                                .frame(width: 360, height: 135)
                        }

                        Text("Walk the streets of \(vm.get_current_country()) right where you are.")
                            .foregroundColor(.white)
                            .frame(width:240)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 20))
                            .offset(y:-20)
                        NavigationLink {
                            _DModelView(vm: vm, model: vm.current_user?.country ?? "Mexico").navigationBarBackButtonHidden(true)
                            .toolbar(.hidden, for: .tabBar)
                        } label: {
                            Text("Let's go!")
                                .font(.system(size: 16))
                                .foregroundStyle(.black)
                                .padding()
                        }
                        .frame(maxWidth: 105, maxHeight: 30)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 14.0))
                        .offset(y:25)
                    }
                    .clipShape(.rect(cornerRadius: 14.0))
                    .padding(.bottom, 8)
                    Spacer()
                }

                
                Text("Explore")
                    .font(Font.custom("Quicksand-Medium", size: 24))
                    .foregroundColor(.cDarkGray)
                    .padding(.bottom, -5)
                    .padding(.leading, 10)
                
                ScrollView(.horizontal) {
                    HStack{
                        Spacer(minLength: 10)
                        
                        NavigationLink {
                            PopCultureSectionView(vm: vm)
                                .navigationBarBackButtonHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                        } label: {
                            ZStack{
                                if let popCultureImage = popCultureImage {
                                    Image(uiImage: popCultureImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 207)
                                        
                                } else {
                                    // Placeholder image or loading indicator
                                    ProgressView()
                                        .frame(width: 150, height: 207)
                                }
                                Text("Pop Culture")
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                    .font(.system(size: 24))
                                    .offset(x: -5, y:75)
                            }
                            .clipShape(.rect(cornerRadius: 14.0))
                            .padding(.bottom, 15)
                        }
                        
                        NavigationLink{
                            FoodCategorySectionView(vm: vm)
                                .navigationBarBackButtonHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                        } label: {
                            ZStack{
                                if let foodImage = foodImage {
                                    Image(uiImage: foodImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 207)
                                        
                                } else {
                                    // Placeholder image or loading indicator
                                    ProgressView()
                                        .frame(width: 150, height: 207)
                                }
                                Text("Food")
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                    .font(.system(size: 24))
                                    .offset(x: -35, y:75)
                            }
                            .clipShape(.rect(cornerRadius: 14.0))
                            .padding(.bottom, 15)
                        }
                        
                        NavigationLink {
                            CustomsSectionView(vm:vm)
                                .navigationBarBackButtonHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                        } label: {
                            ZStack{
                                if let customsImage = customsImage {
                                    Image(uiImage: customsImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 207)
                                        
                                } else {
                                    // Placeholder image or loading indicator
                                    ProgressView()
                                        .frame(width: 150, height: 207)
                                }
                                Text("Customs")
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                    .font(.system(size: 24))
                                    .offset(x: -20, y:75)
                            }
                            .clipShape(.rect(cornerRadius: 14.0))
                            .padding(.bottom, 15)
                        }
                        
                        NavigationLink {
                            PlacesSectionView(vm:vm)
                                .navigationBarBackButtonHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                        } label: {
                            ZStack{
                                if let placesImage = placesImage {
                                    Image(uiImage: placesImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 207)
                                        
                                } else {
                                    // Placeholder image or loading indicator
                                    ProgressView()
                                        .frame(width: 150, height: 207)
                                }
                                Text("Places")
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                    .font(.system(size: 24))
                                    .offset(x: -25, y:75)
                            }
                            .clipShape(.rect(cornerRadius: 14.0))
                            .padding(.bottom, 15)
                        }
                        
                        Spacer(minLength: 10)
                    }
                }
                .scrollIndicators(.hidden)
                
            }
            .navigationBarBackButtonHidden()
            .onChange(of: vm.current_user?.country, initial: true) {
                print("yuhhhh")
                points = vm.current_user?.points ?? 0
                vm.checkIfStreakIsIntact(userID: vm.current_user?.id ?? "") { _ in
                    streak = vm.current_user?.streak ?? 0
                    vm.updateLastLoggedOn(userID: vm.current_user?.id ?? "") { _ in
                        
                    }
                }
                badges = vm.current_user?.badges.count ?? 0
                vm.quizViewModel!.load_quizzes() { result in
                }
                vm.wordGuessingViewModel!.load_word_guessings() { result in
                }
                vm.connectionsViewModel!.load_connections() { result in
                }
                vm.getImage(imageName: "\(vm.get_current_country().lowercased())_quiz_home") { image in
                    quizImage = image
                }
                vm.getImage(imageName: "\(vm.get_current_country().lowercased())_connections_home") { image in
                    connectionsImage = image
                }
                vm.getImage(imageName: "\(vm.get_current_country().lowercased())_artour_home") { image in
                    artourImage = image
                }
                vm.getImage(imageName: "\(vm.get_current_country().lowercased())_popculture_home") { image in
                    popCultureImage = image
                }
                vm.getImage(imageName: "\(vm.get_current_country().lowercased())_food_home") { image in
                    foodImage = image
                }
                vm.getImage(imageName: "\(vm.get_current_country().lowercased())_customs_home") { image in
                    customsImage = image
                }
                vm.getImage(imageName: "\(vm.get_current_country().lowercased())_places_home") { image in
                    placesImage = image
                }
                
            }
                if popUpOpen {
                    Color.gray.opacity(0.7)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            popUpOpen = false
                        }
                    ChangeCountryView(vm: vm, popUpOpen: $popUpOpen)
                }
                
            }
        }
        
    }
    
}

#Preview {
    HomeView(vm: ViewModel())
}
