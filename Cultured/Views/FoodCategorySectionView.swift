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
        NavigationStack {
            ZStack(alignment:.topLeading){
                if let uiImage = uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: screenWidth, height: screenHeight * 0.8)
                        .ignoresSafeArea()
                } else {
                    ProgressView()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: screenWidth/2, height: screenHeight/2)
                        .offset(y:screenHeight * -0.2)
                }
                
                BackButton()
                    .offset(x:10,y:30)
                
                VStack (alignment:.leading){
                            Text("Food")
                                .foregroundColor(.cDarkGray)
                                .font(Font.custom("Quicksand-SemiBold", size: 32))
                                .padding(.leading,32)
                                .padding(.top,30)
                            Text(vm.current_user?.country ?? "Mexico")
                                .foregroundColor(.cMedGray)
                                .padding(.leading, 32)
                            Text("Categories")
                                .font(Font.custom("Quicksand-Medium", size: 24))
                                .foregroundColor(.cDarkGray)
                                .padding(.top, 20)
                                .padding(.leading,32)
                                .padding(.bottom,15)
                            HStack (spacing: 13) {
                                NavigationLink {
                                    FoodView(vm: vm)
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
                                    DrinkView(vm: vm)
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
                            .padding(.bottom, 8)
                            .frame(width:screenWidth)
         
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
                            .frame(width: screenWidth)

                    Spacer()
                }
                .frame(width: screenWidth, height: screenHeight)
                .background(.cPopover)
                .clipShape(.rect(cornerRadius: 40))
                .offset(y:screenHeight * 0.6)

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

