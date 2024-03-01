//
//  FoodViewExtended.swift
//  Cultured
//
//  Created by Aditi Umapathy on 2/29/24.
//

import SwiftUI

struct FoodViewExtended: View {
    
    let categories = ["Popular", "Seasonal", "Regional"]
    let items = [("Horchata", "horchata"), ("Mangonada", "mangonada")]
    let allItems = [("Food item", "Short description of the item", "horchata")]
    
    var body: some View {
        ScrollView {
            VStack {
                Image("food2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                
                Text("Food")
                    .font(.custom("Quicksand-Semibold", size: 32))
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                
                Text("Mexico")
                    .font(.custom("SF Pro Display Regular", size: 16))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                
                Picker("Categories", selection: .constant(1)) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(items, id: \.0) { item in
                            VStack {
                                Image(item.1)
                                    .resizable()
                                    .frame(width: 130, height: 200)
                                    .cornerRadius(14)
                                Text(item.0)
                            }
                        }
                    }
                    .padding()
                }
                ForEach(allItems, id: \.0) { item in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 100)
                            .cornerRadius(14)
                            .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)

                        HStack {
                            Image(item.2)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .cornerRadius(14)
                                .clipped()

                            VStack(alignment: .leading) {
                                Text(item.0)
                                font(.custom("SF Pro Display Regular", size: 16))
                                Text(item.1)
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                            }
                            .padding(.leading)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    struct FoodViewExtended_Previews: PreviewProvider {
        static var previews: some View {
            FoodViewExtended()
        }
    }
}
