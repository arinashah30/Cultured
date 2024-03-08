//
//  ResultsView.swift
//  Cultured
//
//  Created by amber verma on 3/4/24.
//

import SwiftUI

struct CircularProgressBar: View {
    var progress: CGFloat
    var total: Int
    
    let buttonWidth: CGFloat = 153.29
    let buttonHeight: CGFloat = 57
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 15.0)
                    .opacity(0.3)
                    .foregroundColor(Color.red)
                    .frame(width: 285, height: 285)
                
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.red)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear, value: progress)
                    .frame(width: 285, height: 285)
                
                Text("\(Int(progress * CGFloat(total)))/\(total)")
                    .font(Font.custom("Quicksand-SemiBold", size: 80))
                    .foregroundColor(Color.red)
            }
            .padding()
            .padding(.bottom, 100)
            
            Spacer()
            
            VStack {
                Text("You answered \(Int(progress * CGFloat(total))) out of \(total)")
                    .font(Font.custom("Quicksand-SemiBold", size: 24))
                    .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                    .fixedSize(horizontal: true, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                Text("questions correctly!")
                    .font(Font.custom("Quicksand-SemiBold", size: 24))
                    .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                    .fixedSize(horizontal: true, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    .padding(.bottom, 20)
                
                Text("Points Collected: 48")
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                
                Text("Total Points: 786")
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                    .padding(.top, 20)
            }
            Spacer()
            
            
            VStack{
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Text("New Quiz")
                            .padding()
                            .frame(width: buttonWidth, height: buttonHeight)
                            .background(Color(red: 228/255, green: 228/255, blue: 228/255))
                            .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                            .font(.system(size: 20, weight: .bold))
                    }
                    .cornerRadius(100)
                    
                    Button(action: {
                        
                    }) {
                        Text("Exit")
                            .padding()
                            .frame(width: buttonWidth, height: buttonHeight)
                            .background(Color(red: 228/255, green: 228/255, blue: 228/255))
                            .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                            .font(.system(size: 20, weight: .bold))
                    }
                    .cornerRadius(100)
                }
                .padding()
            }
        }
    }
}

struct ResultsView: View {
    @ObservedObject var vm: QuizViewModel
    var body: some View {
        VStack(alignment: .center) {
            Text("Results")
                .font(Font.custom("Quicksand-SemiBold", size: 32))
                .foregroundColor(.red)
                .padding(.top, -265)
                .padding(.leading, -155)
            
            Text("India - Music")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .padding(.top, -255)
                .padding(.leading, -155)
            
            CircularProgressBar(progress: 0.9, total: 10)
                .frame(width: 200, height: 200)
                .padding(.top, -10)
        }
    }
}

struct CircularProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(vm: QuizViewModel())
    }
}
