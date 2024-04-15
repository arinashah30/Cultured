//
//  FoodView.swift
//  Cultured
//
//  Created by Gustavo Garfias on 02/04/24.
//

import SwiftUI


struct DrinkView: View {
    @ObservedObject var vm: ViewModel
    @State private var selection = Category.Seasonal
    @State var food: Food = Food()

    private enum Category: Hashable {
        //case Popular
        case Seasonal
        case Regional
    }
    
    public var drinkOrange: Color {
        Color(red:255/255, green:122/255, blue:0/255)
    }
    
    
    var body: some View {
        ZStack (alignment: .topLeading){
            Image("Etiquette")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: screenWidth, height: screenHeight * 0.5)
                .ignoresSafeArea()
                .offset(y:-60)
                .background(.blue)
                
            
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
                            Text("Drink")
                                .foregroundColor(drinkOrange)
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
                                            .foregroundColor(drinkOrange)
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
                                            .foregroundColor(drinkOrange)
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
                                        DrinkSubsectionView(fooditems: $food.seasonal)
                                    case .Regional:
                                        DrinkSubsectionView(fooditems: $food.regional)
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
        }
    }
}

struct DrinkCardView: View {
    var imagename: String = "Drink"
    var foodname: String = "Food Item"
    var fooddescription : String = "Short description of item."
    var body: some View {
        HStack {
            Spacer()
            HStack {
                Image(imagename)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screenHeight * 0.1, height: screenHeight * 0.1)
                    .cornerRadius(20)
                VStack(alignment: .leading) {
                    Text(foodname)
                        .font(.system(size: 20))
                    Text(fooddescription)
                        .font(.system(size: 16))
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

struct DrinkSubsectionView: View {
    @Binding var fooditems: [String : String]
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                Spacer(minLength: 15)
                VStack {
                    Image("Horchata")
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    Text("Horchata")
                }
                
                VStack {
                    Image("Mangonada")
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    Text("Mangonada")
                }
                
                VStack {
                    Image("Horchata")
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    Text("Horchata")
                }
                
                VStack {
                    Image("Mangonada")
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    Text("Mangonada")
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
        
        ForEach(Array(fooditems.keys), id: \.self) { fooditem in
            DrinkCardView(foodname: fooditem, fooddescription: fooditems[fooditem] ?? "Description")
        }
    }
}

#Preview {
    DrinkView(vm: ViewModel())
}
