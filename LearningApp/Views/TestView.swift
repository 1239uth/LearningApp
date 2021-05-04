//
//  TestView.swift
//  LearningApp
//
//  Created by Uthman Mohamed on 2021-05-04.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model: ContentModel
    @State private var selectedAnswerIndex: Int?
    @State private var submitted = false
    @State private var numCorrect = 0
    
    var body: some View {
        
        VStack (alignment: .leading) {
            if model.currentQuestion != nil {
                
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                
                CodeTextView()
                
                ScrollView {
                    VStack {
                        ForEach (0..<model.currentQuestion!.answers.count, id: \.self) { index in
                            
                            Button(action: {
                                selectedAnswerIndex = index
                            }){
                                ZStack {
                                    if !submitted {
                                        RectangleCard(colour: index == selectedAnswerIndex ? .gray : .white)
                                            .frame(height: 48)
                                    }
                                    else {
                                        if index == selectedAnswerIndex && index == model.currentQuestion!.correctIndex ||
                                            index == model.currentQuestion!.correctIndex {
                                            RectangleCard(colour: .green)
                                                .frame(height: 48)
                                        }
                                        else if index == selectedAnswerIndex && index != model.currentQuestion!.correctIndex {
                                            RectangleCard(colour: .red)
                                                .frame(height: 48)
                                        }
                                        else {
                                            RectangleCard(colour: .white)
                                                .frame(height: 48)
                                        }
                                    }
                                    
                                    Text(model.currentQuestion!.answers[index])
                                        .bold()
                                }
                            }
                            .disabled(submitted)
                        }
                    }
                }
                
                Button(action: {
                    submitted = true
                    if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                        numCorrect += 1
                    }
                }) {
                    ZStack {
                        RectangleCard(colour: .green)
                            .frame(height: 48)
                        Text("Submit")
                            .bold()
                            .colorInvert()
                    }
                    .padding()
                    
                }
                .disabled(selectedAnswerIndex == nil)
            }
        }
        .accentColor(Color(.label))
        .padding()
        .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
    }
}
