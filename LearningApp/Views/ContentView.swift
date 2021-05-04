//
//  ContentView.swift
//  LearningApp
//
//  Created by Uthman Mohamed on 2021-05-03.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        ScrollView {
            LazyVStack (alignment: .leading) {
                if model.currentModule != nil {
                    ForEach (0..<model.currentModule!.content.lessons.count) { lessonIndex in
                        
                        NavigationLink(destination: ContentDetailView()
                                        .onAppear {
                                            model.beginLesson(lessonIndex)
                                        })
                        {
                            ContentViewRow(lessonIndex: lessonIndex)
                        }
                        
                    }
                }
            }
            .accentColor(Color(.label))
            .padding()
            .navigationBarTitle("Learn \(model.currentModule?.category ?? "")")
            
        }
    }
}
