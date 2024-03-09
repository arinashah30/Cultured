//
//  ConnectionsResultsView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI

struct ConnectionsResultsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: ConnectionsViewModel
    
    let category_colors: [Color] = [.init(red: 252 / 255, green: 179 / 255, blue: 179 / 255),
                                    .init(red: 255 / 255, green: 219 / 255, blue: 165 / 255),
                                    .init(red: 171 / 255, green: 232 / 255, blue: 186 / 255),
                                    .init(red: 153 / 255, green: 194 / 255, blue: 223 / 255)]

    var body: some View {
        VStack {
            
            back
            
            if !vm.categories.isEmpty {
                category_block(categories: vm.categories)
            } else {
                Text("No categories available")
            }
            
            back_to_home
            
            history
        }
    }
    
    func category_block(categories: [String]) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(categories.indices, id: \.self) { index in
                CategoryView(category: categories[index],
                         words: ["Word 1", "Word 2", "Word 3", "Word 4"],
                         bg_color: category_colors[index % category_colors.count])
            }
        }
        .padding()
    }
    
    var history: some View {
        List {
            Section {
                ForEach(0..<vm.history.count, id: \.self) { index in
                    VStack() {
                        HStack {
                            ForEach((vm.history[index].indices), id: \.self) { item in
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .foregroundColor(.black)
                                        .opacity(0.6)
                                        .frame(width: 85, height: 50)
                                    
                                    Text(vm.history[index][item].content)
                                        .padding(5)
                                        .foregroundStyle(.white)
                                        .font(.system(size: 20))
                                        .minimumScaleFactor(0.01)
                                        .aspectRatio(contentMode: .fit)
                                }
                            }
                        }
                    }
                    .frame(height: 50)
                }
                .listRowSeparator(.hidden)
            } header: {
                Text("History")
            }
        }
        .listStyle(.plain)
    }
    
    var back: some View {
        HStack {
            Button() {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "lessthan.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.black, Color.secondary)
                    .frame(width: 50)
            }
            
            Spacer()
        }
    }
    
    var back_to_home: some View {
        Button(action: {
            //implement switching screens
        }) {
            Text("Back to Home")
                .frame(width: 200 , height: 60, alignment: .center)
                .font(.system(size: 24))
        }
         .background(Color.init(red: 236/255, green: 236/255, blue: 236/255))
         .foregroundColor(Color.black)
         .cornerRadius(30)
         .disabled(vm.selection.count < 4 ? true : false)

    }
    
}

struct CategoryView: View {
    var category: String
    var words: [String]
    var bg_color: Color
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(category)
                .font(.headline)
                .padding(.bottom, 5)
            HStack {
                Spacer()
                ForEach(words, id: \.self) { word in
                    Text(word)
                        .padding(5)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 5)
                }
                Spacer()
            }
        }
        .padding(10)
        .background(bg_color)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}


#Preview {
    ConnectionsResultsView(vm: ConnectionsViewModel())
}
