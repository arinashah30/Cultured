//
//  EtiquetteView.swift
//  Cultured
//
//  Created by Triem le on 3/12/24.
//

import SwiftUI

struct EtiquetteView: View {
    @ObservedObject var vm: ViewModel
    @State private var offset: CGSize = .zero
    @State private var isDragging: Bool = false
    @State private var currentIndex: Int = 0
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
                    ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(.white)
                                    .shadow(radius: 5)

                                Text("Swipe me")
                            }
                            .frame(width: 300, height: 450)
                            .offset(offset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        offset = value.translation
                                        isDragging = true
                                    }
                                    .onEnded { value in
                                        withAnimation {
                                            if offset.width < -100 {
                                                offset.width = -400
                                            } else if offset.width > 100 {
                                                offset.width = 400
                                            } else {
                                                offset = .zero
                                            }
                                            isDragging = false
                                        }
                                    }
                            )
                            .opacity(isDragging ? 1 : 0.8)
                    .shadow(radius: 4, x: 0, y: 4)

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


