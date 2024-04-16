//
//  FoodView.swift
//  Cultured
//
//  Created by Gustavo Garfias on 02/04/24.
//

import SwiftUI


public let screenWidth = UIScreen.main.bounds.size.width
public let screenHeight = UIScreen.main.bounds.size.height

struct FoodView: View {
    @ObservedObject var vm: ViewModel
    @State private var selection = Category.Seasonal
    @State var food: Food = Food()
    @State var popup: Bool = false
    @State var popupTitle: String = "Title"
    @State var popupDescription: String = "Description"
    @State var popupImage: String = "Drink"
    
    
    private enum Category: Hashable {
        //case Popular
        case Seasonal
        case Regional
    }
    
    public var foodRed: Color {
        Color(red:247/255, green:64/255, blue:64/255)
    }
    
    
    var body: some View {
        ZStack (alignment: .topLeading){
            Image("Etiquette")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: screenWidth, height: screenHeight * 0.5)
                .ignoresSafeArea()
                .offset(y:-60)
            
            
            BackButton()
            
            VStack{
                Spacer()
                ZStack (alignment: .topLeading){
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2 / 3)
                        .clipShape(.rect(cornerRadius: 40))
                        .foregroundColor(Color.cPopover)
                        .offset(x:-3)
                    

                        VStack (alignment: .leading){
                            Text("Food")
                                .foregroundColor(Color(red: 0.97, green: 0.25, blue: 0.25))
                                .font(Font.custom("Quicksand-SemiBold", size: 32))
                                .padding(.leading, 32)

                            Text(vm.current_user?.country ?? "Mexico")
                                .foregroundColor(.cMedGray)
                                .padding(.leading, 32)
                            
                            
                            HStack {
                                Spacer()
//                                Button {
//                                    selection = .Popular
//                                } label: {
//                                    if selection == .Popular {
//                                        Text("Popular")
//                                            .font(Font.custom("Quicksand-Semibold", size: 16))
//                                            .foregroundColor(foodRed)
//                                            .underline()
//                                            .padding(.leading, 23)
//                                    } else {
//                                        Text("Popular")
//                                            .font(Font.custom("Quicksand-Semibold", size: 16))
//                                            .foregroundColor(.cMedGray)
//                                            .padding(.leading, 23)
//                                    }
//                                }
                                
                                Button {
                                    selection = .Seasonal
                                } label: {
                                    if selection == .Seasonal {
                                        Text("Seasonal")
                                            .font(Font.custom("Quicksand-Semibold", size: 16))
                                            .foregroundColor(foodRed)
                                            .underline()
                                            .padding(.leading, 23)
                                    } else {
                                        Text("Seasonal")
                                            .font(Font.custom("Quicksand-Semibold", size: 16))
                                            .foregroundColor(.cMedGray)
                                            .padding(.leading, 23)
                                    }
                                }
                                Button {
                                    selection = .Regional
                                } label: {
                                    if selection == .Regional {
                                        Text("Regional")
                                            .font(Font.custom("Quicksand-Semibold", size: 16))
                                            .foregroundColor(foodRed)
                                            .underline()
                                            .padding(.leading, 23)
                                    } else {
                                        Text("Regional")
                                            .font(Font.custom("Quicksand-Semibold", size: 16))
                                            .foregroundColor(.cMedGray)
                                            .padding(.leading, 23)
                                    }
                                }
                                Spacer()
                            }
                            .padding(.bottom, 10)
                            .padding(.top,1)
 
                                ScrollView(.vertical) {
                                    VStack(alignment:.leading){
                                    switch selection {
//                                    case .Popular:
//                                        FoodPopularView()
                                    case .Seasonal:
                                        FoodSubsectionView(vm: vm, type: "seasonal", fooditems: $food.seasonal, popup: $popup, popupTitle: $popupTitle, popupDescription: $popupDescription, popupImage: $popupImage)
                                    case .Regional:
                                        FoodSubsectionView(vm: vm, type: "regional", fooditems: $food.regional, popup: $popup, popupTitle: $popupTitle, popupDescription: $popupDescription, popupImage: $popupImage)
                                    }
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
            vm.getInfoFood(countryName: vm.current_user?.country ?? "Mexico") {food in
                self.food = food
                print("SELF FOOD \(self.food)")
            }
        }.popup(isPresented: $popup) {
            ZStack {
                DetailView(vm: vm, image: $popupImage, title: $popupTitle, description: $popupDescription)
            }
        }
    }
    struct FoodCardView: View {
        @ObservedObject var vm: ViewModel
        var imagename: String = "Drink"
        var foodname: String = "Food Item"
        var fooddescription : String = "Short description of item."
        @Binding var popup: Bool
        @Binding var popupTitle: String
        @Binding var popupDescription: String
        @Binding var popupImage: String
        @State var uiImage: UIImage? = nil
        
        var body: some View {
            Button(action: {
                popupTitle = foodname
                popupDescription = fooddescription
                popupImage = imagename
                popup = true
            }) {
                HStack {
                    Spacer()
                    HStack {
                        if let uiImage = uiImage {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: screenHeight * 0.1, height: screenHeight * 0.1)
                                .clipped()
                                .cornerRadius(20)
                        } else {
                            // Placeholder image or loading indicator
                            ProgressView()
                                .frame(width: 145, height: 185)
                        }
        
                        VStack(alignment: .leading) {
                            Text(foodname)
                                .font(.system(size: 20))
                            Text(fooddescription)
                                .font(.system(size: 16))
                                .foregroundColor(.cDarkGray)
                                .multilineTextAlignment(.leading)
                        }
                        .frame(width: screenWidth * 0.5)
                    }
                    .frame(width: screenWidth * 0.8, height: screenHeight * 1/9)
                    .background(Color("cBarColor"))
                    .cornerRadius(14)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                    Spacer()
                }.onAppear {
                    vm.getImage(imageName: imagename) { image in
                        uiImage = image
                    }
                }

            }
        }
    }
    
    struct FoodTabView: View {
        @ObservedObject var vm: ViewModel
        var imagename: String
        var name: String
        @State var uiImage: UIImage? = nil
        var body: some View {
            VStack {
                
                if let uiImage = uiImage {
                    Image(imagename)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                } else {
                    // Placeholder image or loading indicator
                    ProgressView()
                        .frame(width: 145, height: 185)
                }
                
                Text(name)
            }.onAppear {
                vm.getImage(imageName: imagename) { image in
                    uiImage = image
                }
            }
        }
    }

    struct FoodSubsectionView: View {
        @ObservedObject var vm: ViewModel
        var type: String
        @Binding var fooditems: [String : String]
        @Binding var popup: Bool
        @Binding var popupTitle: String
        @Binding var popupDescription: String
        @Binding var popupImage: String
        
        var body: some View {
            ScrollView(.horizontal) {
                HStack {
                    Spacer(minLength: 15)
                    
                  
                        ForEach((0..<(fooditems.count / 2)), id: \.self) { index in
                            var fooditem = Array(fooditems.keys)[index]
                            FoodTabView(vm: vm, imagename: "\(vm.get_current_country().lowercased())_\(type)_\(removeWhitespacesFromString(mStr: fooditem))", name: fooditem)
                        }
                    
                    
                
                    Spacer(minLength: 15)
                }
                .padding(.bottom, 20)
            }
            .scrollIndicators(.hidden)
            
            Text("All Items")
                .font(Font.custom("Quicksand-Medium", size: 24))
                .foregroundColor(.cDarkGray)
                .padding(.leading, 32)
            
            ForEach((fooditems.count / 2)..<fooditems.count, id: \.self) { index in
                var fooditem = Array(fooditems.keys)[index]
                FoodCardView(vm: vm, imagename: "\(vm.get_current_country().lowercased())_\(type)_\(removeWhitespacesFromString(mStr: fooditem))", foodname: fooditem, fooddescription: fooditems[fooditem] ?? "Description", popup: $popup, popupTitle: $popupTitle, popupDescription: $popupDescription, popupImage: $popupImage)
            }
        }
    }
}

func removeWhitespacesFromString(mStr: String) -> String {

    let filteredChar = mStr.filter { !$0.isWhitespace }
    return String(filteredChar).lowercased()
}

#Preview {
    FoodView(vm: ViewModel())
}
