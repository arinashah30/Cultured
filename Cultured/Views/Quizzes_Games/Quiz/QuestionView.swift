import SwiftUI

struct QuestionView: View {
    @ObservedObject var vm: QuizViewModel
    @State var selectedCategory = ""
    @State var categories: [String] = []
    @State var nav = false
    
    let buttonColors: [Color] = [Color(red: 255/255, green: 164/255, blue: 164/255), Color(red: 255/255, green: 204/255, blue: 153/255), Color(red: 168/255, green: 220/255, blue: 168/255), Color(red: 179/255, green: 230/255, blue: 255/255)]
    let colorRed: Color = Color(red: 241/255, green: 72/255, blue: 72/255)
    
    let buttonWidth: CGFloat = 350
    let buttonHeight: CGFloat = 57.0
    let buttonRadius=13.0
    @State var totalSteps: Int = 0
    @State var currentStep: Int = 0
    @State var progress: CGFloat = 0.0
    

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
                    .frame(width: UIScreen.main.bounds.width, height: 2*UIScreen.main.bounds.height / 4)
                    .offset(y: UIScreen.main.bounds.height / 10)
                
                                
                VStack(alignment: .leading) {
                    Text("Quiz")
                        .font(Font.custom("Quicksand-semibold",size: 32))
                        .foregroundColor(colorRed)
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
                    .frame(height: 20)
                    
                    ProgressBar(progress: progress, height:5)
                    
                    
                    Text("\(vm.get_current_question().question)")
                        .padding(.top, UIScreen.main.bounds.size.height * 0.015)
                        .font(.system(size: 16))
                        .fixedSize(horizontal: false, vertical: true) // Add this line
                    
                    
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            toggleCategorySelection(category)
                        }) {
                            Text(category)
                            //.padding()
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
                        let result = vm.check_answer(selected: selectedCategory)
                        vm.submit_answer(selectedAnswer: selectedCategory) {
                            if result.isSuccess {
                                nav = true
                            }
                        }
                    }) {
                        Text("Submit")
                            .foregroundColor(.red)
                            .padding(.top, 10)
                            .background(Color.cPopover)
                            .frame(width: buttonWidth, height: buttonHeight)
                            .overlay(
                                RoundedRectangle(cornerRadius:buttonHeight / 2)
                                    .stroke(colorRed, lineWidth: 2)
                            )
                            .font(.system(size:20))
                            .fontWeight(.bold)
                    }.navigationDestination(isPresented: $nav) { destinationView }
                        .padding(.bottom, UIScreen.main.bounds.size.height * 0.15)
                        .frame(maxHeight: 11 * UIScreen.main.bounds.size.height / 12)
                }
                .offset(y:UIScreen.main.bounds.height/4).padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                
            }
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden()
            .padding(.bottom, 100)
            .onAppear(perform: {
                categories = vm.get_answer_choices()
                selectedCategory = ""
                nav = false
                totalSteps = vm.current_quiz!.questions.count
                currentStep = vm.current_quiz!.currentQuestion + 1
                progress = CGFloat(Float(vm.current_quiz!.currentQuestion + 1) / Float(vm.current_quiz!.questions.count))
            })
        }
    }
    
    func toggleCategorySelection(_ category: String) {
        selectedCategory = category
    }
    
    func buttonColor(category: String) -> Color {
        if selectedCategory == category{
            return Color(red: 178 / 255, green: 178 / 255, blue: 178 / 255)
        }else{
            return Color(#colorLiteral(red: 0.9254902005, green: 0.9254902005, blue: 0.9254902005, alpha: 1))
        }
    }
    
    func textColor(category: String) -> Color{
        if selectedCategory == category{
            return .white
        }else{
            return .black
        }
    }
    
    var destinationView: some View {
        let result = vm.check_answer(selected: selectedCategory)
        if result.result {
            return AnyView(QuestionSuccessView(vm: vm, totalSteps: vm.current_quiz!.questions.count, currentStep: vm.current_quiz!.currentQuestion + 1, progress: CGFloat(Float(vm.current_quiz!.currentQuestion + 1) / Float(vm.current_quiz!.questions.count)), answer: selectedCategory, correctAnswer: selectedCategory))
        } else {
            return AnyView(QuestionFailView(vm: vm, totalSteps: vm.current_quiz!.questions.count, currentStep: vm.current_quiz!.currentQuestion + 1, progress: CGFloat(Float(vm.current_quiz!.currentQuestion + 1) / Float(vm.current_quiz!.questions.count)), answer: selectedCategory, correctAnswer: vm.get_current_question().answers[vm.get_current_question().correctAnswer]))
        }
    }
}



//#Preview {
    //var viewModel = ViewModel()
    //@State var navigate = false
    //QuestionView(vm: QuizViewModel(viewModel: ViewModel()))
//}
