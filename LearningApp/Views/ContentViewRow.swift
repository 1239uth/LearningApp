//
//  ContentViewRow.swift
//  LearningApp
//
//  Created by Uthman Mohamed on 2021-05-03.
//

import SwiftUI

struct ContentViewRow: View {
    
    var lessonIndex: Int
    @EnvironmentObject var model: ContentModel
    
    var lesson: Lesson {
        if model.currentModule != nil && lessonIndex < model.currentModule!.content.lessons.count {
            return model.currentModule!.content.lessons[lessonIndex]
        } else {
            return Lesson(id: "", title: "Loading...", video: "", duration: "", explanation: "")
        }
    }
    
    var body: some View {
        
        ZStack (alignment: .leading) {
            
            RoundedRectangle(cornerRadius: 10)
                .colorInvert()
                .frame(height: 66)
                .shadow(color: Color(.label), radius: 3)
            
            HStack {
                
                Text(String(lessonIndex+1))
                    .bold()
                    .padding()
                
                VStack (alignment: .leading){
                    Text(lesson.title)
                        .bold()
                    Text(lesson.duration)
                }
                .padding()
            }
            
        }
    }
}
