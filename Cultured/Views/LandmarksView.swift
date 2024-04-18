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
    @State var titleImage: UIImage? = nil
    
    public var landmarkRed: Color {
        Color(red:241/255, green:72/255, blue:72/255)
    }
    var body: some View {
        VStack {
            ZStack (alignment: .topLeading){
                if let titleImage = titleImage {
                    Image(uiImage: titleImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 400, height: 170)
                        .padding(.top, 80)

                } else {
                    // Placeholder image or loading indicator
                    ProgressView()
                        .frame(width: 145, height: 185)
                }
                
                BackButton()
            }.onAppear {
                vm.getImage(imageName: "\(vm.get_current_country().lowercased())_landmark_0") { image in
                    titleImage = image
                }
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
                    LandmarksSubView(vm: vm, landmarks: $landmarks.landmarkMap, popup: $popup, popupTitle: $popupTitle, popupDescription: $popupDescription, popupImage: $popupImage)
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
    @ObservedObject var vm: ViewModel
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
            ForEach(Array(landmarks.keys.sorted().enumerated()), id: \.element) { index, landmark in
                LandmarkSingleView(vm: vm, imagename: "\(vm.get_current_country().lowercased())_landmark_\(index+1)", name: landmark, description: landmarks[landmark] ?? "Description",popup: $popup, popupTitle: $popupTitle, popupDescription: $popupDescription, popupImage: $popupImage)
            }
        }.scrollIndicators(.hidden)
    }
}

struct LandmarkSingleView: View {
    @ObservedObject var vm: ViewModel
    var imagename: String
    var name: String = "Palacio De Bellas Artes"
    var description : String = "Description."
    @Binding var popup: Bool
    @Binding var popupTitle: String
    @Binding var popupDescription: String
    @Binding var popupImage: String
    @State var uiImage: UIImage? = nil
    
    var body: some View {
        Button(action: {
            popupTitle = name
            popupDescription = description
            popupImage = imagename
            popup = true
        }) {
            VStack {
                if let uiImage = uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: screenWidth * 0.8, height: screenHeight * 0.25)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 18))

                } else {
                    // Placeholder image or loading indicator
                    ProgressView()
                        .frame(width: 145, height: 185)
                }
                Text(name)
                    .font(Font.custom("Quicksand-Medium", size: 20))
            }
           
        }.onAppear {
            vm.getImage(imageName: imagename) { image in
                uiImage = image
            }
        }
        
    }
}



#Preview {
    LandmarksView(vm: ViewModel())
}
