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
    @State var landmarks = Landmarks()
    @Environment(\.dismiss) private var dismiss
    @State var popup: Bool = false
    @State var popupTitle: String = "Palacio De Bellas Artes"
    @State var popupDescription: String = "Description"
    @State var popupImage: String = "LandmarksViewImage2"
    
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
                    Text(vm.current_user?.country ?? "Mexico")
                        .foregroundColor(.cMedGray)
//                    HStack {
//                        Button {
//                            selection = .Regional
//                        } label: {
//                            if selection == .Regional {
//                                Text("Regional")
//                                    .font(Font.custom("Quicksand-Semibold", size: 16))
//                                    .foregroundColor(landmarkRed)
//                                    .underline()
//                                    .padding(.leading, 23)
//                            } else {
//                                Text("Regional")
//                                    .font(Font.custom("Quicksand-Semibold", size: 16))
//                                    .foregroundColor(.cMedGray)
//                                    .padding(.leading, 23)
//                            }
//                        }
//                        
//                        Button {
//                            selection = .Historical
//                        } label: {
//                            if selection == .Historical {
//                                Text("Historical")
//                                    .font(Font.custom("Quicksand-Semibold", size: 16))
//                                    .foregroundColor(landmarkRed)
//                                    .underline()
//                                    .padding(.leading, 23)
//                            } else {
//                                Text("Historical")
//                                    .font(Font.custom("Quicksand-Semibold", size: 16))
//                                    .foregroundColor(.cMedGray)
//                                    .padding(.leading, 23)
//                            }
//                        }
//                        Button {
//                            selection = .Scenic
//                        } label: {
//                            if selection == .Scenic {
//                                Text("Scenic")
//                                    .font(Font.custom("Quicksand-Semibold", size: 16))
//                                    .foregroundColor(landmarkRed)
//                                    .underline()
//                                    .padding(.leading, 23)
//                            } else {
//                                Text("Scenic")
//                                    .font(Font.custom("Quicksand-Semibold", size: 16))
//                                    .foregroundColor(.cMedGray)
//                                    .padding(.leading, 23)
//                            }
//                        }
//                                
//                    }
//                    switch selection {
//                    case .Historical:
//                        LandmarksSubView()
//                    case .Regional:
//                        LandmarksSubView()
//                    case .Scenic:
//                        LandmarksSubView()
//                    }
                    LandmarksSubView(landmarks: $landmarks.landmarkMap, popup: $popup, popupTitle: $popupTitle, popupDescription: $popupDescription, popupImage: $popupImage)
                }
                .padding(.top, 30)
                .padding(.leading, 40)
            }.edgesIgnoringSafeArea(.bottom)
        }
        .padding(.top, -50)
        .onAppear {
            vm.getInfoLandmarks(countryName: vm.current_user?.country ?? "Mexico") { land in
                self.landmarks = land
            }
        }
        .popup(isPresented: $popup) {
            ZStack {
                DetailView(vm: vm, image: $popupImage, title: $popupTitle, description: $popupDescription)
            }
        }

    }
}

private enum Tabs: Hashable {
    case Regional
    case Historical
    case Scenic
}

struct LandmarksSubView: View {
    @Binding var landmarks: [String:String]
    @Binding var popup: Bool
    @Binding var popupTitle: String
    @Binding var popupDescription: String
    @Binding var popupImage: String
    
    var body: some View {
        Text("Top Attractions")
            .font(Font.custom("Quicksand-Medium", size: 24))
            .padding(.top, 10)
        ScrollView {
            ForEach(Array(landmarks.keys), id: \.self) { landmark in
                LandmarkSingleView(name: landmark, description: landmarks[landmark] ?? "Description",popup: $popup, popupTitle: $popupTitle, popupDescription: $popupDescription, popupImage: $popupImage)
            }
        }
    }
}

struct LandmarkSingleView: View {
    var imagename: String = "LandmarksViewImage2"
    var name: String = "Palacio De Bellas Artes"
    var description : String = "Description."
    @Binding var popup: Bool
    @Binding var popupTitle: String
    @Binding var popupDescription: String
    @Binding var popupImage: String
    
    var body: some View {
        Button(action: {
            popupTitle = name
            popupDescription = description
            popupImage = imagename
            popup = true
        }) {
            VStack {
                Image(imagename)
                Text(name)
                    .font(Font.custom("Quicksand-Medium", size: 20))
            }
           
        }
        
    }
}



#Preview {
    LandmarksView(vm: ViewModel())
}
