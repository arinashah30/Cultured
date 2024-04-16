//
//  FoodCategorySectionView.swift
//  Cultured
//
//  Created by Rethika Ambalam on 2/20/24.
//

import SwiftUI

struct FoodCategorySectionView: View {
    @ObservedObject var vm: ViewModel
    @State var uiImage: UIImage? = nil
    
    var body: some View {
        NavigationStack{
            ZStack (alignment: .topLeading){
                if let uiImage = uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: screenWidth, height: screenHeight * 0.8)
                        .offset(y:screenHeight * -0.1)
                } else {
                    ProgressView()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: screenWidth/2, height: screenHeight/2)
                        .offset(y:screenHeight * -0.2)
                }
                
                BackButton()
                    .offset(x:10,y:30)
                
                VStack{
                    Spacer()
                    ZStack (alignment: .topLeading){
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width, height: 350)
                            .clipShape(.rect(cornerRadius: 40))
                            .foregroundColor(.cPopover)
                        VStack (alignment: .leading){
                            Text("Food")
                                .foregroundColor(.cDarkGray)
                                .font(Font.custom("Quicksand-SemiBold", size: 32))
                            Text(vm.current_user?.country ?? "Mexico")
                                .foregroundColor(.cMedGray)
                            Text("Categories")
                                .font(Font.custom("Quicksand-Medium", size: 24))
                                .foregroundColor(.cDarkGray)
                                .padding(.top, 20)
                            HStack {
                                NavigationLink {
                                    FoodView(vm:vm)
                                        .navigationBarBackButtonHidden(true)
                                        .toolbar(.hidden, for: .tabBar)
                                } label: {
                                    Text("Food")
                                        .font(.system(size: 20))
                                        .foregroundColor(.cDarkGrayConstant)
                                        .padding()
                                }
                                .frame(maxWidth: 159, maxHeight: 57)
                                .background(Color.cRed)
                                .clipShape(.rect(cornerRadius: 14.0))
                                
                                NavigationLink {
                                    DrinkView(vm:vm)
                                        .navigationBarBackButtonHidden(true)
                                        .toolbar(.hidden, for: .tabBar)
                                } label: {
                                    Text("Drink")
                                        .font(.system(size: 20))
                                        .foregroundColor(.cDarkGrayConstant)
                                        .padding()
                                }
                                .frame(maxWidth: 159, maxHeight: 57)
                                .background(Color.cOrange)
                                .clipShape(.rect(cornerRadius: 14.0))
                            }
                            .shadow(radius: 4, x: 0, y: 4)
                            
                            HStack {
                                Spacer()
                                Button {} label: {
                                    Text("Quiz Me!")
                                        .foregroundColor(.cMedGray)
                                        .font(.system(size: 20))
                                }
                                Spacer()
                            }
                            .padding(.top, 30)
                            .padding(.leading, -35)
                            
                        }
                        .padding(.top, 30)
                        .padding(.leading, 32)
                    }
                    //.padding(.leading, 7)
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }
            .onAppear {
                vm.getImage(imageName: "\(vm.get_current_country().lowercased())_food_home") { image in
                    uiImage = image
                }
            }
        }
    }
}

#Preview {
    FoodCategorySectionView(vm: ViewModel())
}

