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
    
    var body: some View {
        VStack {
            if !vm.categories.isEmpty {
                category_block(categories: vm.categories)
            } else {
                Text("No categories available")
            }
        }
    }
    
    func category_block(categories: [String]) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(categories.indices, id: \.self) { index in
                Text(categories[index])
            }
        }
        .padding()
    }
}
struct CategoryView: View {
    var category: String
    var words: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(category)
                .font(.headline)
                .padding(.bottom, 5) // Add bottom padding to the category text
            HStack {
                ForEach(words, id: \.self) { word in
                    Text(word)
                        .padding(5)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 5) // Add horizontal padding to the word text
                }
            }
        }
        .padding(10) // Add padding to the whole CategoryView
        .background(Color.gray.opacity(0.1)) // Add a light gray background to CategoryView
        .cornerRadius(8) // Add corner radius to CategoryView
        .shadow(radius: 2) // Add shadow to CategoryView
    }
}


#Preview {
    ConnectionsResultsView(vm: ConnectionsViewModel())
}
