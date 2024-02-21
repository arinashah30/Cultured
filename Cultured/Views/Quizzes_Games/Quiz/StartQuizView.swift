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
    
    let buttonColors: [Color] = [Color(red: 255/255, green: 164/255, blue: 164/255), Color(red: 255/255, green: 204/255, blue: 153/255), Color(red: 168/255, green: 220/255, blue: 168/255), Color(red: 179/255, green: 230/255, blue: 255/255)]
    
    let buttonWidth: CGFloat = 150
    let buttonHeight: CGFloat = 50
    
    var body: some View {
        ZStack {
            // the background image
            Image("backgroundImage")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.5)
            // the quiz
            VStack {
                Spacer()
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
                                            //.padding()
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
