//
//  EtiquetteView.swift
//  Cultured
//
//  Created by Triem le on 3/12/24.
//

import SwiftUI

private struct Facts: Identifiable {
    let name: String
    let image: Image
    var id: String { name }
}

struct EtiquetteView: View {
    @ObservedObject var vm: ViewModel
    @State private var selection = Tabs.Social
    @State var etiquette = Etiquette()
    public var etiquetteOrange: Color {
        Color(red:255/255, green:122/255, blue:0/255)
    }
    
    var body: some View {
        VStack {
            ZStack (alignment: .topLeading){
                Image("Etiquette")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 400, height: 200)
                
                BackButton()
                
            }
            
            ZStack (alignment: .topLeading){
                Rectangle()
                    .frame(width: 395, height: 600)
                    .clipShape(.rect(cornerRadius: 40))
                    .foregroundColor(.cPopover)
                VStack (alignment: .leading){
                    Text("Etiquette")
                        .foregroundColor(etiquetteOrange)
                        .font(Font.custom("Quicksand-SemiBold", size: 32))
                    Text(vm.current_user?.country ?? "Mexico")
                        .foregroundColor(.cMedGray)
                    
                    //                    HStack {
                    //                        Button {
                    //                            selection = .Social
                    //                        } label: {
                    //                            if selection == .Social {
                    //                                Text("Social")
                    //                                    .font(Font.custom("Quicksand-Semibold", size: 16))
                    //                                    .foregroundColor(etiquetteOrange)
                    //                                    .underline()
                    //                                    .padding(.leading, 31)
                    //                            } else {
                    //                                Text("Social")
                    //                                    .font(Font.custom("Quicksand-Semibold", size: 16))
                    //                                    .foregroundColor(.cMedGray)
                    //                                    .padding(.leading, 31)
                    //                            }
                    //                        }
                    //
                    //                        Button {
                    //                            selection = .Meal
                    //                        } label: {
                    //                            if selection == .Meal {
                    //                                Text("Meal")
                    //                                    .font(Font.custom("Quicksand-Semibold", size: 16))
                    //                                    .foregroundColor(etiquetteOrange)
                    //                                    .underline()
                    //                                    .padding(.leading, 42)
                    //                            } else {
                    //                                Text("Meal")
                    //                                    .font(Font.custom("Quicksand-Semibold", size: 16))
                    //                                    .foregroundColor(.cMedGray)
                    //                                    .padding(.leading, 42)
                    //                            }
                    //                        }
                    //                        Button {
                    //                            selection = .Public
                    //                        } label: {
                    //                            if selection == .Public {
                    //                                Text("Public")
                    //                                    .font(Font.custom("Quicksand-Semibold", size: 16))
                    //                                    .foregroundColor(etiquetteOrange)
                    //                                    .underline()
                    //                                    .padding(.leading, 42)
                    //                            } else {
                    //                                Text("Public")
                    //                                    .font(Font.custom("Quicksand-Semibold", size: 16))
                    //                                    .foregroundColor(.cMedGray)
                    //                                    .padding(.leading, 42)
                    //                            }
                    //                        }
                    //
                    //                    }
                    //                    .padding(.bottom, 10)
                    //                    .padding(.top, 0)
                    
                    //                    switch selection {
                    //                    case .Social:
                    //                        EtiquetteSocialView()
                    //                    case .Meal:
                    //                        EtiquetteMealView()
                    //                    case .Public:
                    //                        EtiquettePublicView()
                    //                    }
                    
                    EtiquetteSubView(facts: $etiquette.etiquetteMap)
                    
                    
                }
                .padding(.top, 30)
                .padding(.leading, 40)
                
                
                
            }
        }.onAppear {
            vm.getInfoEtiquettes(countryName: vm.current_user?.country ?? "Mexico") { etiquette in
                self.etiquette = etiquette
            }
        }
    }
    private enum Tabs: Hashable {
        case Public
        case Meal
        case Social
    }
    
    
    struct EtiquetteSubView: View {
        @Binding var facts: [String : String]
        var body: some View{
            VStack {
                TabView {
                    ForEach(Array(facts.keys), id: \.self) { fact in
                        ZStack (alignment: .top){
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.enterButton)
                            VStack {
                                Image("Drink")
                                    .resizable()
                                    .frame(width: 250.0, height: 100)
                                    .cornerRadius(20)
                                Text(fact)
                                    .lineLimit(10)
                                    .padding(.top, 20)
                                    .padding([.leading, .trailing], 30)
                                    .foregroundColor(.cDarkGrayConstant)
                                    .font(Font.custom("Quicksand-SemiBold", size: 20))
                            
                                Text(facts[fact] ?? "Description")
                                    .minimumScaleFactor(0.3)
                                    //.lineLimit(10)
                                    .padding(.vertical, 20)
                                    .padding([.leading, .trailing], 30)
                                    .foregroundColor(.cDarkGrayConstant)
                                    .font(Font.custom("Quicksand-SemiBold", size: 20))
                            }
                            .padding(.top, 20)
                        }.frame(width: 300, height: 450)
                        
                    }
                    
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .interactive))
            }
            .frame(width: 320, height: 450)
        }
    }
}

#Preview {
    EtiquetteView(vm: ViewModel())
}
