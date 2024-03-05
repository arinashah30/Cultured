//
//  StartQuizView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI

struct StartQuizView: View {
    @ObservedObject var vm: QuizViewModel
    @State private var selectedCategories: Set<String> = []
    let categories = ["Pop Culture", "Food", "Customs", "Places"]
    
    let buttonColors: [Color] = [Color(red: 252/255, green: 179/255, blue: 179/255), Color(red: 255/255, green: 219/255, blue: 165/255), Color(red: 171/255, green: 232/255, blue: 186/255), Color(red: 153/255, green: 194/255, blue: 223/255)]
    
    let buttonWidth: CGFloat = 156
    let buttonHeight: CGFloat = 57
    
    var body: some View {
        ZStack {
            // the background image
            Image("StartQuizImage")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(width:UIScreen.main.bounds.width, height: 2*UIScreen.main.bounds.width/3)
                .offset(y:-UIScreen.main.bounds.width/3.5)
            
            Button(action: {
                // Button Action
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20))
                    .foregroundColor(.cDarkGray)
                    .padding(16)
                    .background(Color.cLightGray.opacity(0.8))
                    .clipShape(Circle())
                    .offset(x: -140, y: -350)
            }
            
        // the quiz
            VStack{
                Image("quizQuestionPicture")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width:UIScreen.main.bounds.width, height: 2*UIScreen.main.bounds.width/3)
                    .offset(y:-UIScreen.main.bounds.width/2)
                }

            VStack{

                RoundedRectangle(cornerRadius: 40)
                    .fill(Color.white)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
                    .offset(y:UIScreen.main.bounds.height / 4)
                }

            
            VStack {
                Spacer()
                VStack(alignment: .leading) {
                    Text("Quiz")
                        .font(Font.custom("Quicksand-SemiBold", size: 32))
                    Text("India")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 157/255, green: 157/255, blue: 157/255))
                    
                    Text("Select Category")
                        .font(Font.custom("Quicksand", size: 20))
                        .padding(.vertical, 10)
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            ForEach(categories.prefix(2), id: \.self) { category in
                                Button(action: {
                                    toggleCategorySelection(category)
                                }) {
                                    HStack {
                                        Text(category)
                                            .font(.system(size: 20))
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
                                .cornerRadius(13)
                            }
                        }
                        
                        
                        HStack(spacing: 16) {
                            ForEach(categories.suffix(2), id: \.self) { category in
                                Button(action: {
                                    toggleCategorySelection(category)
                                }) {
                                    HStack {
                                        Text(category)
                                            .font(.system(size: 20))
                                        if selectedCategories.contains(category) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(checkmarkColor(for: category))
                                                .padding(.trailing, 8)
                                                .padding(.leading, 0)
                                        }
                                    }
                                }
                                .frame(width: buttonWidth, height: buttonHeight)
                                .background(buttonColors[categories.firstIndex(of: category)!])
                                .foregroundColor(.black)
                                .cornerRadius(13)
                            }
                        }
                        
                    }
                }
                
                Button(action: {
                }) {
                    Text("Start")
                        .padding()
                        .foregroundColor(.black)
                        .font(.system(size: 20, weight: .bold))
                }
                .frame(width: buttonWidth, height: buttonHeight)
                .background(Color(red: 228/255, green: 228/255, blue: 228/255))
                .cornerRadius(buttonHeight / 2)
                .padding()
            }
        }
    }
    
    
    func toggleCategorySelection(_ category: String) {
        selectedCategories = []
        if selectedCategories.contains(category) {
            selectedCategories.insert(category)
        } else {
            selectedCategories.insert(category)
        }
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
struct StartQuizViewPreviews: PreviewProvider {
    static var previews: some View {
        StartQuizView(vm: QuizViewModel())
    }
}
