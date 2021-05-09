//
//  HomeView.swift
//  LearningApp
//
//  Created by Uthman Mohamed on 2021-05-01.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                Text("What do you want to do today?")
                    .padding(.leading, 20)
                ScrollView {
                    LazyVStack {
                        ForEach (model.modules) { module in
                            
                            VStack (spacing: 20) {
                                // For bug....
                                NavigationLink(
                                    destination: EmptyView()) {}
                                
                                NavigationLink(destination: ContentView()
                                                .onAppear {
                                                    model.getLessons(module: module) {
                                                        model.beginModule(module.id)
                                                    }
                                                },
                                               tag: module.id.hash,
                                               selection: $model.currentContentSelection)
                                {
                                    HomeViewRow(image: module.content.image, title: module.category, description: module.content.description, count: module.content.lessons.count, time: module.content.time)
                                }
                                
                                NavigationLink(
                                    destination: TestView()
                                        .onAppear {
                                            model.getQuestions(module: module) {
                                                model.beginTest(module.id)
                                            }
                                        },
                                    tag: module.id.hash,
                                    selection: $model.currentTestSelection) {
                                        HomeViewRow(image: module.test.image, title:   module.category, description: module.test.description, count: module.test.questions.count, time: module.test.time)
                                }
                                
                            }
                            
                        }
                        
                    }
                    .accentColor(Color(.label))
                    .padding()
                }
            }
            .navigationBarTitle("Get Started")
            .onChange(of: model.currentContentSelection, perform: { value in
                if value == nil {
                    model.currentModule = nil
                }
            })
            .onChange(of: model.currentTestSelection, perform: { value in
                if value == nil {
                    model.currentModule = nil
                }
            })
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}
