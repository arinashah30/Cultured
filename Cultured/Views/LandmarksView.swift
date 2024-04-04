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
                    .frame(width: 395, height: 400)
                    .clipShape(.rect(cornerRadius: 40))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                VStack (alignment: .leading){
                    Text("Landmarks")
                        .foregroundColor(landmarkRed)
                        .font(Font.custom("Quicksand-SemiBold", size: 32))
                    Text("Mexico")
                        .foregroundColor(.cMedGray)
                    HStack {
                        //use tab view instead of buttons
                       // TabView(selection: $selection) {
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
                            Text("Historical")
                                .font(Font.custom("Quicksand-Semibold", size: 16))
                                .foregroundColor(.cMedGray)
                                .padding(.leading, 30)
                        }
                        Button {
                            selection = .Scenic
                        } label: {
                                Text("Scenic")
                                    .font(Font.custom("Quicksand-Semibold", size: 16))
                                    .foregroundColor(.cMedGray)
                                    .padding(.leading, 30)
                        }
                                
                            
                            
                         
                        //}
                    }
                    switch selection {
                    case .Historical:
                        LandmarksRegionalView()
                    case .Regional:
                        LandmarksRegionalView()
                    case .Scenic:
                        LandmarksRegionalView()
                    }
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

struct LandmarksRegionalView: View {
    var body: some View {
        VStack{
            Text("Top Attractions")
                .font(Font.custom("Quicksand-Medium", size: 24))
                .padding(.top, 10)
            Image("LandmarksViewImage2")
            Text("Palacio De Bellas Artes")
                .font(Font.custom("Quicksand-Medium", size: 20))
            Image("LandmarksViewImage3")
                .padding(.top, 20)
        }
    }
}


#Preview {
    LandmarksView(vm: ViewModel())
}
