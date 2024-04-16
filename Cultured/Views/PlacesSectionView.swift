//
//  PlacesSectionView.swift
//  Cultured
//
//  Created by Rethika Ambalam on 2/20/24.
//

import SwiftUI

struct PlacesSectionView: View {
    @ObservedObject var vm: ViewModel
    @State var uiImage: UIImage? = nil
    
    var body: some View {
        NavigationStack {
            ZStack (alignment: .topLeading){
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
                
                VStack{
                    Spacer()
                    ZStack (alignment: .topLeading){
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width, height: 350)
                            .clipShape(.rect(cornerRadius: 40))
                            .foregroundColor(.cPopover)
                        VStack (alignment: .leading){
                            Text("Places")
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
                            HStack {
                                .padding(.leading,32)
                                .padding(.bottom,15)
                                NavigationLink {
                                    LandmarksView(vm:vm)
                                        .navigationBarBackButtonHidden(true)
                                        .toolbar(.hidden, for: .tabBar)
                                } label: {
                                    Text("Landmarks")
                                        .font(.system(size: 20))
                                        .foregroundColor(.cDarkGrayConstant)
                                        .padding()
                                }
                                .frame(maxWidth: 159, maxHeight: 57)
                                .background(Color.cRed)
                                .clipShape(.rect(cornerRadius: 14.0))
                                
                                NavigationLink {
                                    LandmarksView(vm:vm)
                                        .navigationBarBackButtonHidden(true)
                                        .toolbar(.hidden, for: .tabBar)
                                } label: {
                                    Text("Major Cities")
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
                                Button {} label: {
                                    Text("Quiz Me!")
                                        .foregroundColor(.cMedGray)
                                        .font(.system(size: 20))
                                }
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
            .frame(width: screenWidth, height: screenHeight)
        }
        .onAppear {
            vm.getImage(imageName: "\(vm.get_current_country().lowercased())_places_home") { image in
                uiImage = image
        }
    }
}
}

#Preview {
    PlacesSectionView(vm: ViewModel())
}

