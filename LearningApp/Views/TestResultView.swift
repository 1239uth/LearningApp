//
//  TestResultView.swift
//  LearningApp
//
//  Created by Uthman Mohamed on 2021-05-04.
//

import SwiftUI

struct TestResultView: View {
    
    @EnvironmentObject var model: ContentModel
    var numCorrect: Int
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(resultHeading)
                .font(.title)
            
            Spacer()
            
            Text("You got \(numCorrect) out of \(model.currentModule?.test.questions.count ?? 0) questions right")
            
            Spacer()
            
            Button(action: {
                model.currentTestSelection = nil
            }) {
                ZStack {
                    RectangleCard(colour: .green)
                        .frame(height: 48)
                    Text("Complete")
                        .bold()
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
        }
    }
    
    var resultHeading: String {
        
        guard model.currentModule != nil else {
            return ""
        }
        
        let percent = Double(numCorrect) / Double(model.currentModule!.test.questions.count)
        
        if percent > 0.5 {
            return "Awesome!"
        } else if percent > 0.2 {
            return "Doing Great!"
        } else {
            return "Keep Learning!"
        }
    }
}

