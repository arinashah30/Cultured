//
//  ConnectionsGameView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI

struct ConnectionsGameView: View {
    @ObservedObject var vm: ConnectionsViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button() {
                    // back
                } label: {
                    Image(systemName: "lessthan.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.black, Color.secondary)
                        .frame(width: 50)
                }
                
                Spacer()
            }
            
            ScrollView(.vertical) {
                options
            }
            
            Button(action: {
                   //do action
            }) {
                Text("Submit")
                    .frame(width: 200 , height: 60, alignment: .center)
                    .font(.system(size: 24))
            }
             .background(Color.orange)
             .foregroundColor(Color.black)
             .cornerRadius(30)
            
            Spacer()
        }
        .padding()
    }
    
    var options : some View {
        LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem()]) {
            ForEach(vm.options.indices, id: \.self) { index in
                OptionView(option: vm.options[index])
                    .aspectRatio(2/3, contentMode: .fit)
                // When the View is tapped, the choose function in viewModel is called
                    .onTapGesture {
                        vm.choose(vm.options[index])
                        print(vm.options[index])
                    }
            }
        }
    }
}

struct OptionView: View {
    
    // creates a card that's of type Card from our model
    var option: Connections.Option
    
    var body: some View {

            ZStack {
                RoundedRectangle(cornerRadius: 10.0)
                    .foregroundColor(option.isSelected || option.isMatched ? .black : .gray)
                    .opacity(0.4)
                    .frame(width: 85, height: 75)

                Text(option.content)
                    .font(.system(size: 25))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(option.isSelected || option.isMatched ? .white : .black)
            }
    }
}

#Preview {
    ConnectionsGameView(vm: ConnectionsViewModel())
}
