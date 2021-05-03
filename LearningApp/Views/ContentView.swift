//
//  ContentView.swift
//  LearningApp
//
//  Created by Uthman Mohamed on 2021-05-03.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model: ContentModel
    var module: Module
    
    var body: some View {
        ScrollView {
            
            LazyVStack (alignment: .leading) {
                if model.currentModule != nil {
                    ForEach (0..<model.currentModule!.content.lessons.count) { lessonIndex in
                        
                        NavigationLink(destination: ContentDetailView()) {
                            ContentViewRow(lessonIndex: lessonIndex)
                        }
                        
                    }
                }
            }
            .padding()
            .navigationTitle("Learn \(module.category)")
            
        }
        .onAppear {
            model.beginModule(module.id)
        }
    }
}
