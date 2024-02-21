////
////  QuestionView.swift
////  Cultured
////
////  Created by Arina Shah on 2/6/24.
////
//
//import SwiftUI
//
//struct QuestionView: View {
//    let choices = ["Choice 1", "Choice 2", "Choice 3", "Choice 4"]
//    @ObservedObject var vm: QuizViewModel
//    var body: some View {
//        ZStack{
//            Image("quizQuestionPicture")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//            VStack{
//                LazyVGrid(columns:[GridItem(.flexible()), GridItem(.flexible())]){
//                    ForEach(choices,id: \.self){ label in Button(){
//                            Text(label)
//                                .padding()
//                                .foregroundColor(.white)
//                                .background(Color.blue)
//                                .cornerRadius(8)
//                    }
//                    }
//
//                }
//
//                Button("Submit"){}
//            }
//
//
//
//
//        }
//    }
//}
//
//#Preview {
//    QuestionView(vm: QuizViewModel())
//}

import SwiftUI

struct QuestionView: View {
    @ObservedObject var vm: QuizViewModel
    @State private var selectedCategories: Set<String> = []
    let categories = ["Pop Culture", "Food", "Customs", "Places"]
    
    let buttonColors: [Color] = [Color(red: 255/255, green: 164/255, blue: 164/255), Color(red: 255/255, green: 204/255, blue: 153/255), Color(red: 168/255, green: 220/255, blue: 168/255), Color(red: 179/255, green: 230/255, blue: 255/255)]
    
    let buttonWidth: CGFloat = 150
    let buttonHeight: CGFloat = 50
    
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
                    .frame(width: UIScreen.main.bounds.width, height: 2*UIScreen.main.bounds.height / 4)
//                    .offset(y:UIScreen.main.bounds.height / 4)
            }
            
    
            // the quiz
            
                VStack {
                    VStack(alignment: .leading) {
                        Text("Quiz")
                            .font(.title)
                        Text("India")
                            .font(.subheadline)
                        
                        Text("Select Category")
                            .font(.headline)
                            .padding(.vertical, 10)
                        VStack(spacing: 16) {
                            HStack(spacing: 16) {
                                ForEach(categories.prefix(2), id: \.self) { category in
                                    Button(action: {
                                        toggleCategorySelection(category)
                                    }) {
                                        HStack {
                                            Text(category)
                                                .padding()
                                            if selectedCategories.contains(category) {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(checkmarkColor(for: category))
                                                    .padding(.trailing, 8)
                                            }
                                        }
                                    }
                                    .frame(width: buttonWidth, height: buttonHeight)
                                    .background(buttonColors[categories.firstIndex(of: category)!])
                                    .foregroundColor(.black)
                                    .cornerRadius(8)
                                }
                            }
                            
                            HStack(spacing: 16) {
                                ForEach(categories.suffix(2), id: \.self) { category in
                                    Button(action: {
                                        toggleCategorySelection(category)
                                    }) {
                                        HStack {
                                            Text(category)
                                                .padding()
                                            if selectedCategories.contains(category) {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(checkmarkColor(for: category))
                                                    .padding(.trailing, 8)
                                            }
                                        }
                                    }
                                    .frame(width: buttonWidth, height: buttonHeight)
                                    .background(buttonColors[categories.firstIndex(of: category)!])
                                    .foregroundColor(.black)
                                    .cornerRadius(8)
                                }
                            }
                            .padding()
                        }
                    }
                    
                    Button(action: {
                    }) {
                        Text("Start")
                            .padding()
                            .font(.system(size: 20, weight: .bold))
                    }
                    .frame(width: buttonWidth, height: buttonHeight)
                    .background(Color.cLightGray)
                    .foregroundColor(.black)
                    .cornerRadius(buttonHeight / 2)
                    .padding()
                    
                }/*.offset(y:UIScreen.main.bounds.height/6)*/
            
        }

        }
    
    func toggleCategorySelection(_ category: String) {
        selectedCategories=[]
        selectedCategories.insert(category)
//        if selectedCategories.contains(category) {
//            selectedCategories.remove(category)
//        } else {
//            selectedCategories.insert(category)
//        }
    }
    
    func checkmarkColor(for category: String) -> Color {
        switch category {
            case "Pop Culture":
                return .red
            case "Food":
                return .orange
            case "Customs":
                return .green
            case "Places":
                return .blue
            default:
                return .white
        }
    }
}



#Preview {
    QuestionView(vm: QuizViewModel())
}


