//
//  FoodView.swift
//  Cultured
//
//  Created by Aditi Umapathy on 2/26/24.
//

import SwiftUI

struct FoodDetailView: View {
    var body: some View {
        VStack {
            Image("food1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 700)
            VStack {
                VStack(alignment: .leading) {
                    Text("Food")
                        .font(.custom("Quicksand-Semibold", size: 32))
                        .foregroundColor(Color(hex: "#404040"))
                    Text("Mexico")
                        .font(.custom("SF Pro Display regular", size: 16))
                        .foregroundColor(Color.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .top])
                Text("Categories")
                
                    .font(.custom("Quicksand-Medium", size: 24))
                    .foregroundColor(Color(hex: "#404040"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(15)
                
                HStack(spacing:16) {
                    CategoryButton(title: "Food", backgroundColor: Color(hex: "#FCB3B3"), textColor: Color.black)
                    CategoryButton(title: "Drink", backgroundColor: Color(hex: "#FFDBA5"), textColor: Color.black)
                }
                .padding(.horizontal)
                Button(action: {
                    
                }) {
                    HStack {
                        Image(systemName: "lightbulb")
                            .foregroundColor(Color.gray)
                        Text("Quiz Me!")
                            .font(.custom("SF Pro Display Regular", size: 16))
                    }
                    .foregroundColor(Color.gray)
                    .padding()
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                Spacer()
            }
            .frame(minHeight: 600)
            .clipShape(.rect(cornerRadius: 50))
        }
    }
}

struct CategoryButton: View {
    var title: String
    var backgroundColor: Color
    var textColor: Color

    var body: some View {
        Button(action: {
        }) {
            Text(title)
                .font(.custom("Quicksand-Medium", size: 20))
                .foregroundColor(textColor)
                .padding()
                .frame(minWidth: 100, maxWidth: .infinity)
                .background(backgroundColor)
                .cornerRadius(14)
                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
        }
        .padding(4)
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = Double((rgbValue >> 16) & 0xFF) / 255.0
        let g = Double((rgbValue >> 8) & 0xFF) / 255.0
        let b = Double(rgbValue & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}

struct FoodDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetailView()
    }
}
