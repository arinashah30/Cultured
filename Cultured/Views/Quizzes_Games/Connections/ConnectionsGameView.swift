//
//  ConnectionsGameView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI

struct ConnectionsGameView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: ConnectionsViewModel
    
    var body: some View {
        if vm.mistakes_remaining == 0 {
            Text("You lost")
        } else if vm.correct_categories == 4 {
            Text("You won")
        } else {
            VStack {
                back
                
                options
                    .padding(.bottom, 20)
                
                submit
                
                mistakes
                
                history
                
                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden()
        }
    }
    
    var back: some View {
        HStack {
            Button() {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "lessthan.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.cDarkGray, Color.secondary)
                    .frame(width: 50)
            }
            
            Spacer()
        }
    }
    
    var options: some View {
        LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem()]) {
            ForEach(vm.options.indices, id: \.self) { index in
                OptionView(option: vm.options[index])
                    .aspectRatio(2/3, contentMode: .fit)
                    .onTapGesture {
                        vm.select(vm.options[index])
                        print(vm.options[index])
                    }
            }
        }
    }
    
    var mistakes: some View {
        HStack {
            Text("Mistakes remaining:")
            ForEach(0..<vm.mistakes_remaining, id: \.self) { index in
                Circle()
                    .fill(.orange)
                    .frame(width: 10, height: 10)
            }
        }
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
    
    var submit: some View {
        Button(action: {
            vm.submit()
        }) {
            Text("Submit")
                .frame(width: 200 , height: 60, alignment: .center)
                .font(.system(size: 24))
        }
         .background(Color.orange)
         .foregroundColor(Color.black)
         .cornerRadius(30)
         .opacity(vm.selection.count < 4 ? 0.5 : 0.8)
         .disabled(vm.selection.count < 4 ? true : false)
    }
}

struct OptionView: View {
    
    var option: Connections.Option
    
    var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 10.0)
                    .foregroundColor(option.isSubmitted ? .green : option.isSelected ? .cDarkGray : .cMedGray)
                    .opacity(option.isSelected || option.isSubmitted ? 0.6 : 0.2)
                    .frame(width: 85, height: 75)

                Text(option.content)
                    .font(.system(size: 25))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(option.isSelected ? .cLightGray : .cDarkGray)
                    .padding(7)
            }
    }
}

#Preview {
    ConnectionsGameView(vm: ConnectionsViewModel())
}
