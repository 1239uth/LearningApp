//
//  TestView.swift
//  LearningApp
//
//  Created by Uthman Mohamed on 2021-05-04.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        VStack {
            if model.currentQuestion != nil {
                
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                
                CodeTextView()
                
            }
        }
        .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
