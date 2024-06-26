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
    @State var already_guessed: Bool = false
    @State var goHome: Bool = false
    var colors: [Color] = [.red, .orange, .green, .blue]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
            VStack {
                back
                    .padding(.bottom, 20)
                
                answers
                
                options
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                
                if vm.correct_history.count == 4 {
                    back_home
                } else {
                    submit
                    mistakes
                }
                
                history
                
            }
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden()
    }
    
    var back: some View {
        ZStack {
            HStack {
                
                BackButton()
                    //.position(x:UIScreen.main.bounds.size.width/10, y:UIScreen.main.bounds.size.height/250)
                
                Spacer()
                
                if vm.one_away {
                    temp_alert_one_away
                }
                
                if vm.already_guessed {
                    temp_alert_already_guessed
                }
                
                Spacer()
                
                BackButton()
                    .hidden()
            }
        }
    }
    
    var temp_alert_one_away: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 30.0)
                    .frame(width: 200, height: 45)
                    .foregroundStyle(Color.cDarkGray)
                    .opacity(0.6)
                
                Text("One word away...")
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
            }
        }
    }
    
    var temp_alert_already_guessed: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 30.0)
                    .frame(width: 200, height: 45)
                    .foregroundStyle(.cDarkGray)
                    .opacity(0.6)
                
                Text("Already guessed!")
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
            }
            
            //Spacer()
        }
    }
    
    var answers: some View {
        ForEach(vm.correct_history.keys.indices, id: \.self) { index in
            ZStack {
                RoundedRectangle(cornerRadius: 10.0)
                    .foregroundColor(colors[index])
                    .opacity(0.4)
                    .frame(width: UIScreen.main.bounds.size.width - 40, height: 65)
                
                VStack {
                    Text((vm.correct_history[vm.correct_history_keys[index]]![0].category))
                        .bold()
                    Text("\(vm.correct_history[vm.correct_history_keys[index]]![0].content), \(vm.correct_history[vm.correct_history_keys[index]]![1].content), \(vm.correct_history[vm.correct_history_keys[index]]![2].content), \(vm.correct_history[vm.correct_history_keys[index]]![3].content)")
                    }
                }
                
            }
    }
    
    var options: some View {
        LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem()], spacing: 10) {
            ForEach(vm.options.indices, id: \.self) { index in
                OptionView(option: vm.options[index])
                    .aspectRatio(2/3, contentMode: .fit)
                    .onTapGesture {
                        vm.select(vm.options[index])
                    }
            }
        }
    }
    
    var mistakes: some View {
        HStack {
            Text("Mistakes remaining:")
            Circle()
                .fill(.orange)
                .frame(width: 10, height: 10)
                .opacity(vm.mistakes_remaining < 1 ? 0.4 : 1.0)
            Circle()
                .fill(.orange)
                .frame(width: 10, height: 10)
                .opacity(vm.mistakes_remaining < 2 ? 0.4 : 1.0)
            Circle()
                .fill(.orange)
                .frame(width: 10, height: 10)
                .opacity(vm.mistakes_remaining < 3 ? 0.4 : 1.0)
            Circle()
                .fill(.orange)
                .frame(width: 10, height: 10)
                .opacity(vm.mistakes_remaining < 4 ? 0.4 : 1.0)
        }
    }
    
    var history: some View {
        List {
            Section {
                ForEach(vm.mistake_history_keys.indices, id: \.self) { index in
                        HStack {
                            ForEach(vm.mistake_history_keys[index].indices, id: \.self) { item in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .foregroundStyle(.cDarkGray)
                                        .opacity(1)
                                        .frame(width: vm.mistake_history[vm.mistake_history_keys.reversed()[index]]! ? UIScreen.main.bounds.size.width * 0.2 : UIScreen.main.bounds.size.width * 0.22, height: 50)
                                        .padding(.all, vm.mistake_history[vm.mistake_history_keys.reversed()[index]]! ? 1 : 2)
                                    
                                    Text(vm.mistake_history_keys.reversed()[index][item].content)
                                        .padding(.all, 1)
                                        .foregroundStyle(.cDarkGrayReverse)
                                        .font(.system(size: 16))
                                        .minimumScaleFactor(0.01)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: UIScreen.main.bounds.size.width * 0.18)
                                }
                            }
                            
                            if vm.mistake_history[vm.mistake_history_keys.reversed()[index]]! {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5.0)
                                        .stroke(.cDarkGray, lineWidth: 2)
                                        .foregroundStyle(.white)
                                        .frame(width: 30, height: 46)
                                        .background(.cPopover)
                                    
                                    Triangle()
                                        .fill(Color.orange)
                                        .opacity(0.5)
                                        .frame(width: 28, height: 44)
                                    
                                    Text("1")
                                        .padding(5)
                                        .foregroundStyle(.cDarkGray)
                                        .font(.system(size: 25))
                                        .minimumScaleFactor(0.01)
                                        .aspectRatio(contentMode: .fit)
                                }
                            }
                    }
                    .frame(height: 40)
                }
                .listRowSeparator(.hidden)
            } header: {
                Text("History")
            }
        }
        .listStyle(.plain)
        //.frame(minHeight: 300.0)
    }
    
    struct Triangle: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            return path
        }
    }
    
    var submit: some View {
        Button(action: {
            vm.submit() {}
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    vm.reset_alerts()
                }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 30.0)
                    .frame(width: 180, height: 50)
                    .foregroundStyle(.orange)
                    .opacity(vm.selection.count < 4 ? 0.4 : 1.0)
                
                Text("Submit")
                
                    .font(.system(size: 20))
                    .foregroundStyle(.black)
            }
        }
    }
    
    var back_home: some View {
            Button(action: {
                dismiss()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 30.0)
                        .frame(width: 180, height: 50)
                        .foregroundStyle(.cDarkGray)
                        .opacity(0.2)
                    
                    Text("Back to Home")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                }
            }
        }
}

struct OptionView: View {
    
    var option: Connections.Option
    
    var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 10.0)
                    .foregroundColor(option.isSelected ?  .cDarkGray : .cMedGray)
                    .opacity(option.isSelected ? 0.6 : 0.2)
                    .frame(width: 85, height: 65)

                Text(option.content)
                    .font(.system(size: 16))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(option.isSelected ? .cLightGray : .cDarkGray)
                    .padding(7)
            }
    }
}

#Preview {
    ConnectionsGameView(vm: ConnectionsViewModel(viewModel: ViewModel()))
}
