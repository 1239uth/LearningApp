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
                    
                    if !submitted {
                        submitted = true
                        if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                            numCorrect += 1
                        }
                    } else {
                        submitted = false
                        selectedAnswerIndex = nil
                        model.nextQuestion()
                    }
                    
                }) {
                    ZStack {
                        RectangleCard(colour: .green)
                            .frame(height: 48)
                        Text(buttonText)
                            .bold()
                            .colorInvert()
                    }
                    .padding()
                    
                }
                .disabled(selectedAnswerIndex == nil)
            }
            else {
                TestResultView(numCorrect: numCorrect)
            }
        }
        .accentColor(Color(.label))
        .padding()
        .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
    }
    
    var buttonText: String {
        if submitted && model.currentQuestionIndex+1 == model.currentModule!.test.questions.count {
            return "Finish"
        }
        else if submitted {
            return "Next"
        }
        else {
            return "Submit"
        }
    }
}
