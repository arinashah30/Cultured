//
//  ResultsView.swift
//  Cultured
//
//  Created by amber verma on 3/4/24.
//

import SwiftUI

struct ResultsView: View {
    @ObservedObject var vm: QuizViewModel
    @State var totalPoints: Int = 0
    @State var goHome: Bool = false
    @Environment(\.dismiss) private var dismiss
    //var progress: CGFloat
    //var total: Int
    
    let buttonWidth: CGFloat = 153.29
    let buttonHeight: CGFloat = 57
    
    var body: some View {
        VStack(alignment: .center) {
            BackButton()
                .position(x:UIScreen.main.bounds.size.width/10, y:UIScreen.main.bounds.size.height/250)
            Text("Results")
                .font(Font.custom("Quicksand-SemiBold", size: 32))
                .foregroundColor(.red)
                .padding(.top, -265)
                .padding(.leading, -155)
            
            Text("\(vm.viewModel.get_current_country()) - \(vm.get_current_category())")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .padding(.top, -255)
                .padding(.leading, -155)
            
            
            VStack {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 15.0)
                        .opacity(0.3)
                        .foregroundColor(Color.red)
                        .frame(width: 285, height: 285)
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(vm.current_quiz!.points / 10) / CGFloat(vm.current_quiz!.questions.count))
                        .stroke(style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Color.red)
                        .rotationEffect(Angle(degrees: -90))
                        .animation(.linear, value: CGFloat(vm.current_quiz!.currentQuestion) / CGFloat(vm.current_quiz!.questions.count))
                        .frame(width: 285, height: 285)
                    
                    Text("\(vm.current_quiz!.points / 10)/\(vm.current_quiz!.questions.count)" as String)
                        .font(Font.custom("Quicksand-SemiBold", size: 80))
                        .foregroundColor(Color.red)
                }
                .padding(.bottom, 100)
                
                Text("You answered \(vm.current_quiz!.points / 10) out of \(vm.current_quiz!.questions.count)" as String)
                    .font(Font.custom("Quicksand-SemiBold", size: 24))
                    .foregroundColor(.cDarkGray)
                    .fixedSize(horizontal: true, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                Text("questions correctly!")
                    .font(Font.custom("Quicksand-SemiBold", size: 24))
                    .foregroundColor(.cDarkGray)
                    .fixedSize(horizontal: true, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    .padding(.bottom, 20)
                
                Text("Points Collected: \(vm.current_quiz!.points)")
                    .font(.system(size: 20))
                    .foregroundColor(.cDarkGray)
                
                Text("Total Points: \(totalPoints)")
                    .font(.system(size: 20))
                    .foregroundColor(.cDarkGray)
                    .padding(.top, 10)
                
                Spacer(minLength: 50)
                
                
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Exit")
                        .padding()
                        .frame(width: buttonWidth, height: buttonHeight)
                        .background(.cDarkGray)
                        .foregroundColor(.cPopover)
                        .font(.system(size: 20, weight: .bold))
                }//.navigationDestination(isPresented: $goHome, destination: {HomeView(vm: vm.viewModel)})
                .cornerRadius(100)
            }
            .padding()
            .onAppear(perform: {
                if !vm.current_quiz!.completed {
                    vm.finish_quiz() { totalPoints in
                        self.totalPoints = totalPoints
                    }
                } else {
                    totalPoints = vm.viewModel.current_user!.points
                }
            })
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
    }
    
    
}

struct ResultsViewPreviews: PreviewProvider {
    static var previews: some View {
        ResultsView(vm: QuizViewModel(viewModel: ViewModel()))
    }
}
