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

    @State private var offset: CGSize = .zero
    @State private var isDragging: Bool = false
    @State private var currentIndex: Int = 0
    private let facts : [Facts] = [
        Facts(name: "Fact 1", image: Image("FoodCategory")),
        Facts(name: "Fact 2", image: Image("FoodCategory")),
        Facts(name: "Fact 3", image: Image("FoodCategory")),
        Facts(name: "Fact 4", image: Image("FoodCategory")),
        Facts(name: "Fact 5", image: Image("FoodCategory"))
    ]
    var body: some View {
        VStack {
            ZStack (alignment: .topLeading){
                Image("FoodCategory")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 400, height: 200)
                
                Button {
                    
                } label: {
                    
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .padding(.top, 20)
                            .padding(.leading, 20)
                            .foregroundColor(Color.white.opacity(0.8))
                        Image("Arrow")
                            .padding(.top, 20)
                            .padding(.leading, 18)
                    }
                    
                }
                
            }
            
            ZStack (alignment: .topLeading){
                Rectangle()
                    .frame(width: 395, height: 600)
                    .clipShape(.rect(cornerRadius: 40))
                    .foregroundColor(.white)
                VStack (alignment: .leading){
                    Text("Etiquette")
                        .foregroundColor(.cDarkGray)
                        .font(Font.custom("Quicksand-SemiBold", size: 32))
                    Text("Mexico")
                        .foregroundColor(.cMedGray)
                    
                    VStack {
                        TabView {
                            ForEach(facts) { Facts in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundColor(.enterButton)
                                    VStack{
                                        Facts.image
                                            .resizable()
                                            .frame(width: 250.0, height: 100)
                                            .cornerRadius(20)
                                        Text(Facts.name)
                                            .padding(.top, 20)
                                            .foregroundColor(.cDarkGray)
                                            .font(Font.custom("Quicksand-SemiBold", size: 20))
                                    }.padding(.bottom, 200)
                                }.frame(width: 300, height: 450)
                                
                            }
                            
                        }
                        .tabViewStyle(.page)
                        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                    }
                    .frame(width: 320, height: 450)
                    .offset(offset)
                    
                }
                .padding(.top, 30)
                .padding(.leading, 35)
                
                
                
            }
        }
    }
}

#Preview {
    EtiquetteView(vm: ViewModel())
}
