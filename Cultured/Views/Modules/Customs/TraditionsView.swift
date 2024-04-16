//
//  FoodView.swift
//  Cultured
//
//  Created by Gustavo Garfias on 02/04/24.
//

import SwiftUI


struct TraditionsView: View {
    @ObservedObject var vm: ViewModel
    @State private var selection = Category.Spring
    @State var traditions = Traditions()
    @State var popup: Bool = false
    @State var popupTitle: String = "Title"
    @State var popupDescription: String = "Description"
    @State var popupImage: String = "Drink"
    
    private enum Category: Hashable {
        case Spring
        case Summer
        case Fall
        case Winter
    }
    
    public var traditionsRed: Color {
        Color(red:247/255, green:64/255, blue:64/255)
    }
    
    
    var body: some View {
        ZStack (alignment: .topLeading){
            Image("Traditions")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: screenWidth, height: screenHeight * 0.5)
                .ignoresSafeArea()
                .offset(y:-65)
            
            BackButton()
            
            VStack{
                Spacer()
                ZStack (alignment: .topLeading){
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2 / 3)
                        .clipShape(.rect(cornerRadius: 40))
                        .foregroundColor(.cPopover)
                        .offset(x:-3)
                    
                    
                    VStack (alignment: .leading){
                        Text("Traditions")
                            .foregroundColor(Color(red: 0.97, green: 0.25, blue: 0.25))
                            .font(Font.custom("Quicksand-SemiBold", size: 32))
                            .padding(.leading, 32)
                        
                        Text(vm.current_user?.country ?? "Mexico")
                            .foregroundColor(.cMedGray)
                            .padding(.leading, 32)
                        
                        ScrollView(.vertical) {
                            VStack(alignment:.leading){
                                TraditionsSeasonView(traditions: $traditions.traditionsDictionary, popup: $popup, popupTitle: $popupTitle, popupDescription: $popupDescription, popupImage: $popupImage)
                                
                            }
                        }
                        .padding(.bottom, 30)
                        
                    }
                    .padding(.top, 30)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2 / 3)
                    .scrollIndicators(.hidden)
                }
                .padding(.leading, 7)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        .ignoresSafeArea()
        .onAppear {
            vm.getInfoTraditions(countryName: vm.current_user?.country ?? "Mexico") { trads in
                self.traditions = trads
            }
        }.popup(isPresented: $popup) {
            ZStack {
                DetailView(vm: vm, image: $popupImage, title: $popupTitle, description: $popupDescription)
            }
        }
    }
}

struct TraditionsCardView: View {
    var imagename: String = "Drink"
    var name: String = "Tradition"
    var description : String = "Short description of item."
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
            HStack {
                Spacer()
                HStack {
                    Image(imagename)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: screenHeight * 0.1, height: screenHeight * 0.1)
                        .cornerRadius(20)
                    VStack(alignment: .leading) {
                        Text(name)
                            .font(.system(size: 20))
                        Text(description)
                            .font(.system(size: 16))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.cDarkGray)
                    }
                    .frame(width: screenWidth * 0.5)
                }
                .frame(width: screenWidth * 0.8, height: screenHeight * 1/9)
                .background(Color("cBarColor"))
                .cornerRadius(14)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                Spacer()
            }
            }
    }
}

struct TraditionsSeasonView: View {
    @Binding var traditions: [String : String]
    @Binding var popup: Bool
    @Binding var popupTitle: String
    @Binding var popupDescription: String
    @Binding var popupImage: String
    var body: some View {
        Text("All Items")
            .font(Font.custom("Quicksand-Medium", size: 24))
            .foregroundColor(.cDarkGray)
            .padding(.leading, 32)
        
        ForEach(Array(traditions.keys), id: \.self) { fooditem in
            TraditionsCardView(name: fooditem, description: traditions[fooditem] ?? "Description", popup: $popup, popupTitle: $popupTitle, popupDescription: $popupDescription, popupImage: $popupImage)
        }
    }
}



#Preview {
    TraditionsView(vm: ViewModel())
}
