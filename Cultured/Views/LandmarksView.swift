//
//  LandmarksView.swift
//  Cultured
//
//  Created by Rethika Ambalam on 2/29/24.
//

import SwiftUI

struct LandmarksView: View {
    @ObservedObject var vm: ViewModel
    @State private var selection = Tabs.Regional
    @Environment(\.dismiss) private var dismiss
    
    public var landmarkRed: Color {
        Color(red:241/255, green:72/255, blue:72/255)
    }
    var body: some View {
        VStack {
            ZStack (alignment: .topLeading){
                Image("LandmarksViewImage1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 400, height: 170)
                    .padding(.top, 80)
                
                BackButton()
            }
            
            ZStack (alignment: .topLeading){
                Rectangle()
                    .frame(width: 395)
                    .frame(idealHeight: 600, maxHeight: .infinity)
                    .clipShape(.rect(cornerRadius: 40))
                    .foregroundColor(.cPopover)
                    .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                VStack (alignment: .leading){
                    Text("Landmarks")
                        .foregroundColor(landmarkRed)
                        .font(Font.custom("Quicksand-SemiBold", size: 32))
                    Text("Mexico")
                        .foregroundColor(.cMedGray)
                    HStack {
                        Button {
                            selection = .Regional
                        } label: {
                            if selection == .Regional {
                                Text("Regional")
                                    .font(Font.custom("Quicksand-Semibold", size: 16))
                                    .foregroundColor(landmarkRed)
                                    .underline()
                                    .padding(.leading, 23)
                            } else {
                                Text("Regional")
                                    .font(Font.custom("Quicksand-Semibold", size: 16))
                                    .foregroundColor(.cMedGray)
                                    .padding(.leading, 23)
                            }
                        }
                        
                        Button {
                            selection = .Historical
                        } label: {
                            if selection == .Historical {
                                Text("Historical")
                                    .font(Font.custom("Quicksand-Semibold", size: 16))
                                    .foregroundColor(landmarkRed)
                                    .underline()
                                    .padding(.leading, 23)
                            } else {
                                Text("Historical")
                                    .font(Font.custom("Quicksand-Semibold", size: 16))
                                    .foregroundColor(.cMedGray)
                                    .padding(.leading, 23)
                            }
                        }
                        Button {
                            selection = .Scenic
                        } label: {
                            if selection == .Scenic {
                                Text("Scenic")
                                    .font(Font.custom("Quicksand-Semibold", size: 16))
                                    .foregroundColor(landmarkRed)
                                    .underline()
                                    .padding(.leading, 23)
                            } else {
                                Text("Scenic")
                                    .font(Font.custom("Quicksand-Semibold", size: 16))
                                    .foregroundColor(.cMedGray)
                                    .padding(.leading, 23)
                            }
                        }
                                
                    }
                    switch selection {
                    case .Historical:
                        LandmarksHistoricalView()
                    case .Regional:
                        LandmarksRegionalView()
                    case .Scenic:
                        LandmarksScenicView()
                    }
                }
                .padding(.top, 30)
                .padding(.leading, 40)
            }.edgesIgnoringSafeArea(.bottom)
        }
        .padding(.top, -50)
    }
}

private enum Tabs: Hashable {
    case Regional
    case Historical
    case Scenic
}

struct LandmarksRegionalView: View {
    var body: some View {
            ScrollView{
                Text("Top Attractions")
                    .font(Font.custom("Quicksand-Medium", size: 24))
                    .padding(.top, 10)
                Image("LandmarksViewImage2")
                Text("Palacio De Bellas Artes")
                    .font(Font.custom("Quicksand-Medium", size: 20))
                Image("LandmarksViewImage3")
                    .resizable()
                    .frame(width: 312, height: 181)
                    .cornerRadius(25)
                    .padding(.top, 20)
                Text("Monumento a la Independencia")
                    .font(Font.custom("Quicksand-Medium", size: 20))
            }
            .scrollIndicators(.hidden)
    }
}

struct LandmarksHistoricalView: View {
    var body: some View {
        ScrollView{
            Text("Top Attractions")
                .font(Font.custom("Quicksand-Medium", size: 24))
                .padding(.top, 10)
            Image("LandmarksViewImage2")
            Text("Palacio De Bellas Artes")
                .font(Font.custom("Quicksand-Medium", size: 20))
            Image("LandmarksViewImage3")
                .resizable()
                .frame(width: 312, height: 181)
                .cornerRadius(25)
                .padding(.top, 20)
            Text("Monumento a la Independencia")
                .font(Font.custom("Quicksand-Medium", size: 20))
        }
        .scrollIndicators(.hidden)
    }
}

struct LandmarksScenicView: View {
    var body: some View {
        ScrollView{
            Text("Top Attractions")
                .font(Font.custom("Quicksand-Medium", size: 24))
                .padding(.top, 10)
            Image("LandmarksViewImage2")
            Text("Palacio De Bellas Artes")
                .font(Font.custom("Quicksand-Medium", size: 20))
            Image("LandmarksViewImage3")
                .resizable()
                .frame(width: 312, height: 181)
                .cornerRadius(25)
                .padding(.top, 20)
            Text("Monumento a la Independencia")
                .font(Font.custom("Quicksand-Medium", size: 20))
        }
        .scrollIndicators(.hidden)
    }
}


#Preview {
    LandmarksView(vm: ViewModel())
}
