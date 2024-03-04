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
    var body: some View {
        VStack {
            ZStack (alignment: .topLeading){
                Image("LandmarksViewImage1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 400, height: 170)
                    .padding(.top, 90)
                
                Button {
                    
                } label: {
                    
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .padding(.leading, 20)
                            .foregroundColor(Color.white)
                        Image("Arrow")
                            .padding(.top, 140)
                            .padding(.leading, 18)
                    }
                }
            }
            
            ZStack (alignment: .topLeading){
                Rectangle()
                    .frame(width: 395, height: 400)
                    .clipShape(.rect(cornerRadius: 40))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                VStack (alignment: .leading){
                    Text("Landmarks")
                        .foregroundColor(.cRed)
                        .font(Font.custom("Quicksand-SemiBold", size: 32))
                    Text("Mexico")
                        .foregroundColor(.cMedGray)
                    HStack {
                        //use tab view instead of buttons
                       // TabView(selection: $selection) {
                                Text("Regional")
                                    .font(Font.custom("Quicksand-Semibold", size: 16))
                                    .foregroundColor(.cRed)
                                    .padding(.top, 4)
                                    .padding(.leading, 23)
                                .tag(Tabs.Regional)
                                Text("Historical")
                                    .font(Font.custom("Quicksand-Semibold", size: 16))
                                    .foregroundColor(.cMedGray)
                                    .padding(.top, 4)
                                    .padding(.leading, 20)
                            .padding(.leading, 10)
                            .tag(Tabs.Historical)
                                Text("Scenic")
                                    .font(Font.custom("Quicksand-Semibold", size: 16))
                                    .foregroundColor(.cMedGray)
                                    .padding(.top, 4)
                                    .padding(.leading, 20)
                            
                            .padding(.leading, 10)
                            .tag(Tabs.Scenic)
                        //}
                    }
                    Text("Top Attractions")
                        .font(Font.custom("Quicksand-Medium", size: 24))
                        .padding(.top, 10)
                    Image("LandmarksViewImage2")
                    Text("Palacio De Bellas Artes")
                        .font(Font.custom("Quicksand-Medium", size: 20))
                    Image("LandmarksViewImage3")
                        .padding(.top, 20)
                }
                .padding(.top, 30)
                .padding(.leading, 40)
            }
        }
    }
}

private enum Tabs: Hashable {
    case Regional
    case Historical
    case Scenic
}

#Preview {
    LandmarksView(vm: ViewModel())
}
