//
//  QuestionSuccessView.swift
//  Cultured
//
//  Created by Hannah Huang on 2/29/24.
//

import SwiftUI

struct QuestionSuccessView: View {
    @ObservedObject var vm: QuizViewModel
    @State var next = false
    
    var totalSteps: Int
    var currentStep: Int
    var progress: CGFloat
    
    var answer, correctAnswer: String
    

    
    let buttonColors: [Color] = [Color(red: 255/255, green: 164/255, blue: 164/255), Color(red: 255/255, green: 204/255, blue: 153/255), Color(red: 168/255, green: 220/255, blue: 168/255), Color(red: 179/255, green: 230/255, blue: 255/255)]
    let colorRed: Color = Color(red: 241/255, green: 72/255, blue: 72/255)
    let buttonWidth: CGFloat = 350
    let buttonHeight: CGFloat = 57.0
    let buttonRadius=13.0
    var body: some View {
        NavigationStack {
            ZStack {
                // the background image
                VStack{
                    Image("quizQuestionPicture")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width:UIScreen.main.bounds.width, height: 2*UIScreen.main.bounds.width/3)
                        .offset(y:-UIScreen.main.bounds.width/2)
                    //                .opacity(0.5)
                }
                
                VStack{
                    
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.white)
                        .frame(width: UIScreen.main.bounds.width, height: 2*UIScreen.main.bounds.height / 3)
                        .offset(y: UIScreen.main.bounds.height / 10)
                }
                
                
                // the quiz
                
                VStack{
                    VStack(alignment: .leading) {
                        Text("Quiz")
                            .font(Font.custom("Quicksand-semibold",size: 32))
                            .foregroundColor(colorRed)
                            .padding(.top, UIScreen.main.bounds.size.height * 0.025)
                        HStack{
                            Text("\(vm.viewModel.get_current_country()) - \(vm.get_current_category())")
                                .font(.system(size: 16))
                                .foregroundColor(
                                    Color(red: 157/255, green: 157/255, blue: 157/255))
                            Spacer()
                            Text("\(currentStep)/\(totalSteps)").font(.system(size:16))
                                .foregroundColor(
                                    Color(red: 157/255, green: 157/255, blue: 157/255))
                        }
                        
                        
                        //                        ProgressView(value: progress, total: 1.0)
                        //                                    .progressViewStyle(LinearProgressViewStyle(tint: Color.red))
                        //                                    .frame(height: 19)
                        ProgressBar(progress: progress, height:5)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        Text("Correct Answer!")
                            .foregroundColor(Color(red: 84/255, green: 191/255, blue: 110/255))
                            .font(Font.custom("Quicksand-semibold",size: 24))
                        Text("Congratulations! Here is some more info:")
                            .font(Font.custom("Quicksand-medium",size: 16))
                            .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                        Text("\(vm.get_current_question().correctAnswerDescription)")
                            .padding(.vertical, 20).font(.system(size: 14))
                        
                        VStack(spacing: 16) {
                            ForEach(vm.get_current_question().answers, id: \.self) { category in
                                Button(action: {
                                    
                                }) {
                                    Text(category)
                                        .padding()
                                        .font(.system(.body, design: .rounded)) // Use dynamic type
                                        .minimumScaleFactor(0.5)
                                }
                                .frame(width: buttonWidth, height: buttonHeight)
                                .background(buttonColor(category: category))
                                .foregroundColor(textColor(category: category))
                                .cornerRadius(buttonRadius)
                            }
                            
                        }
                    }
                    
                    Button(action: {
                        vm.next_question()
                        next = true
                    }) {
                        Text("Next")
                            .foregroundColor(colorRed)
                            .padding()
                            .background(Color.white)
                            .frame(width: buttonWidth, height: buttonHeight)
                            .overlay(
                                RoundedRectangle(cornerRadius:buttonHeight / 2)
                                    .stroke(colorRed, lineWidth: 2)
                            )
                            .font(.system(size:20))
                            .fontWeight(.bold)
                            .padding(.top, UIScreen.main.bounds.size.height * 0.02)
                            .padding(.bottom, UIScreen.main.bounds.size.height / 20)
                    }.navigationDestination(isPresented: $next) {
                        if vm.move_to_results() {
                            ResultsView(vm: vm)
                        } else {
                            QuestionView(vm: vm, totalSteps: vm.current_quiz!.questions.count, currentStep: vm.current_quiz!.currentQuestion + 1, progress: CGFloat(Float(vm.current_quiz!.currentQuestion + 1) / Float(vm.current_quiz!.questions.count)))
                        }
                    }
                    
                }.offset(y:UIScreen.main.bounds.height/7).padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                
            }
            //.navigationBarBackButtonHidden()
            .padding(.bottom, UIScreen.main.bounds.size.height / 6)
            
        }
    }
    
//    func toggleCategorySelection(_ category: String) {
//        selectedCategory=category
//    }
    
    func buttonColor(category: String) -> Color {
        if answer==category{
            return Color(red: 84 / 255, green: 191 / 255, blue: 110 / 255)
        }else{
            return Color(#colorLiteral(red: 0.9254902005, green: 0.9254902005, blue: 0.9254902005, alpha: 1))
        }
    }
    func textColor(category: String)->Color{
        if answer==category{
            return .white
        }else{
            return .black
        }
    }
}


//
//#Preview {
//    QuestionSuccessView(vm: QuizViewModel(viewModel: ViewModel()))
//}
