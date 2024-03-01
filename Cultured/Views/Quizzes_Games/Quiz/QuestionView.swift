import SwiftUI

struct QuestionView: View {
    @ObservedObject var vm: QuizViewModel
    @State private var selectedCategory:String = ""
    let categories = ["Ravanhatha", "Sitar", "Morchang", "Veena"]
    
    let buttonColors: [Color] = [Color(red: 255/255, green: 164/255, blue: 164/255), Color(red: 255/255, green: 204/255, blue: 153/255), Color(red: 168/255, green: 220/255, blue: 168/255), Color(red: 179/255, green: 230/255, blue: 255/255)]
    let colorRed: Color = Color(red: 241/255, green: 72/255, blue: 72/255)
    
    let buttonWidth: CGFloat = 153.29
    let buttonHeight: CGFloat = 57.0
    let buttonRadius=13.0
    @State private var totalSteps = 10
    @State private var currentStep = 1
    @State private var progress = 0.1
    

    var body: some View {
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
                    .offset(y: UIScreen.main.bounds.height / 7)
            }
            
    
            // the quiz
            
            VStack{
                    VStack(alignment: .leading) {
                        Text("Quiz")
                            .font(Font.custom("Quicksand-semibold",size: 32))
                            .foregroundColor(colorRed)
                            
                        HStack{
                            Text("India-Music")
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
//                                    .frame(height: 20) 
                        ProgressBar(progress: progress, height:5)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        
                        Text("This bow and string instrument is usually made by the player itself. It is an important folk music instrument of Rajasthan made up of bamboo and coconut shell. It’s strings are made up of horsehair.")
                            .padding(.vertical, 20).font(.system(size: 20))
                        
                        VStack(spacing: 16) {
                            HStack(spacing: 16) {
                                ForEach(categories.prefix(2), id: \.self) { category in
                                    Button(action: {
                                        toggleCategorySelection(category)
                                    }) {
                                        HStack {
                                            Text(category)
                                                .padding().font(.system(size:20))
                                            
                                        }
                                    }
                                    .frame(width: buttonWidth, height: buttonHeight)
                                    .background(buttonColor(category: category))
                                    .foregroundColor(textColor(category: category))
                                    .cornerRadius(buttonRadius)
                                }
                            }.frame(maxWidth: .infinity, alignment: .center)
                            
                            HStack(spacing: 16) {
                                ForEach(categories.suffix(2), id: \.self) { category in
                                    Button(action: {
                                        toggleCategorySelection(category)
                                    }) {
                                        HStack {
                                            Text(category)
                                                .padding().font(.system(size:20))
                                            
                                        }
                                    }
                                    .frame(width: buttonWidth, height: buttonHeight)
                                    .background(buttonColor(category: category))
                                    .foregroundColor(textColor(category: category))
                                    .cornerRadius(buttonRadius)
                                }
                            }.frame(maxWidth: .infinity, alignment: .center)
                            
                        }
                    }
                    
                    Button(action: {
                    }) {
                        Text("Submit")
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.white)
                            .frame(width: buttonWidth, height: buttonHeight)
                            .overlay(
                                RoundedRectangle(cornerRadius:buttonHeight / 2)
                                    .stroke(colorRed, lineWidth: 2)
                            )
                            .font(.system(size:20))
                            .fontWeight(.bold)
                    }.padding(.top, 20)
                    
                    
                }.offset(y:UIScreen.main.bounds.height/7).padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
            
        }

        }
    
    func toggleCategorySelection(_ category: String) {
        selectedCategory=category
    }
    
    func buttonColor(category: String) -> Color {
        if selectedCategory==category{
            return Color(red: 178 / 255, green: 178 / 255, blue: 178 / 255)
        }else{
            return Color(#colorLiteral(red: 0.9254902005, green: 0.9254902005, blue: 0.9254902005, alpha: 1))
        }
    }
    func textColor(category: String)->Color{
        if selectedCategory==category{
            return .white
        }else{
            return .black
        }
    }
}



#Preview {
    QuestionView(vm: QuizViewModel())
}


