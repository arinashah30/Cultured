//
//  QuestionFailView.swift
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
    
    var answer: String
    var correctAnswer: String
    
    
    let buttonColors: [Color] = [Color(red: 255/255, green: 164/255, blue: 164/255), Color(red: 255/255, green: 204/255, blue: 153/255), Color(red: 168/255, green: 220/255, blue: 168/255), Color(red: 179/255, green: 230/255, blue: 255/255)]
    let colorRed: Color = Color(red: 241/255, green: 72/255, blue: 72/255)
    let buttonWidth: CGFloat = 350
    let buttonHeight: CGFloat = 57.0
    let buttonRadius=13.0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(uiImage: UIImage(data: Data(base64Encoded: vm.current_quiz!.image.components(separatedBy: ",")[1], options: .ignoreUnknownCharacters)!)!)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width:UIScreen.main.bounds.width, height: 2*UIScreen.main.bounds.width/3)
                    .offset(y:-UIScreen.main.bounds.width/2 - 20)
                
                BackButton()
                    .position(x:UIScreen.main.bounds.size.width * 1.1 / 12, y:-UIScreen.main.bounds.size.height * 0.0001)
                
                
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color.cPopover)
                    .frame(width: UIScreen.main.bounds.width, height: 3*UIScreen.main.bounds.height / 5)
                    .offset(y: UIScreen.main.bounds.height / 10)
                
                VStack(alignment: .leading) {
                    Text("Quiz")
                        .foregroundColor(colorRed)
                        .font(Font.custom("Quicksand-semibold",size: 32))
                        .offset(y:UIScreen.main.bounds.size.height/72)
                        .padding(.bottom, UIScreen.main.bounds.size.height * 0.02)
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
                    
                    ProgressBar(progress: progress, height:5)

                    Text("Correct Answer!")
                        .foregroundColor(Color(red: 84/255, green: 191/255, blue: 110/255))
                        .font(Font.custom("Quicksand-semibold",size: 24))
                    
                    Text("Congratulations! Here is some more info:")
                        .font(Font.custom("Quicksand-medium",size: 16))
                        .foregroundColor(.cDarkGray)

                    Text("\(vm.get_current_question().correctAnswerDescription)")
                        .padding(.top, UIScreen.main.bounds.size.height * 0.015)
                        .font(.system(size: 14))
                        .fixedSize(horizontal: false, vertical: true) // Add this line
                    
                    ForEach(vm.get_current_question().answers, id: \.self) { category in
                        Button(action: {
                            
                        }) {
                            Text(category)
                                .font(.system(.body, design: .rounded))
                                .minimumScaleFactor(0.4)
                        }
                        .frame(width: buttonWidth, height: buttonHeight)
                        .background(buttonColor(category: category))
                        .foregroundColor(textColor(category: category))
                        .cornerRadius(buttonRadius)
                        .padding(.top, 10)
                    }
                    
                    
                    Button(action: {
                        vm.next_question()
                        next = true
                    }) {
                        Text("Next")
                            .foregroundColor(colorRed)
                            .padding(.top, 10)
                            .background(Color.cPopover)
                            .frame(width: buttonWidth, height: buttonHeight)
                            .overlay(
                                RoundedRectangle(cornerRadius:buttonHeight / 2)
                                    .stroke(colorRed, lineWidth: 2)
                            )
                            .font(.system(size:20))
                            .fontWeight(.bold)
                            //.padding(.top, UIScreen.main.bounds.size.height * 0.01)
                            //.padding(.bottom, UIScreen.main.bounds.size.height / 30)
                    }.navigationDestination(isPresented: $next) {
                        if vm.move_to_results() {
                            ResultsView(vm: vm)
                        } else {
                            QuestionView(vm: vm, totalSteps: vm.current_quiz!.questions.count, currentStep: vm.current_quiz!.currentQuestion + 1, progress: CGFloat(Float(vm.current_quiz!.currentQuestion + 1) / Float(vm.current_quiz!.questions.count)))
                        }
                    }
                    .padding(.bottom, UIScreen.main.bounds.size.height * 0.1)
                    .frame(maxHeight: 11 * UIScreen.main.bounds.size.height / 12)
                }
                .offset(y:UIScreen.main.bounds.height/5).padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                
            }
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden()
            .padding(.bottom, 100)
            
        }
    }
    
//    func toggleCategorySelection(_ category: String) {
//        selectedCategory=category
//    }
    
    func buttonColor(category: String) -> Color {
        if correctAnswer==category{
            return Color(red: 84 / 255, green: 191 / 255, blue: 110 / 255)
        }
        else if answer==category{
            return colorRed
        }
        else{
            return Color(#colorLiteral(red: 0.9254902005, green: 0.9254902005, blue: 0.9254902005, alpha: 1))
        }
    }
    func textColor(category: String)->Color{
        if answer==category || correctAnswer==category{
            return .white
        }else{
            return .black
        }
    }
}



//#Preview {
//    QuestionFailView(vm: QuizViewModel(viewModel: ViewModel()))
//}
