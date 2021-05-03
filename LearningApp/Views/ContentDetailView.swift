//
//  ContentDetailView.swift
//  LearningApp
//
//  Created by Uthman Mohamed on 2021-05-03.
//

import SwiftUI
import AVKit

struct ContentDetailView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        let lesson = model.currentLesson
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ?? ""))
        VStack {
            if url != nil {
                VideoPlayer(player: AVPlayer(url: url!))
                    .cornerRadius(10)
            }
            
            CodeTextView()
            
            if model.hasNextLesson() {
                Button(action: {
                    model.nextLesson()
                }, label: {
                    ZStack {
                        
                        RectangleCard(colour: .green)
                            .frame(height:48)
                        
                        Text("Next Lesson: \(model.currentModule!.content.lessons[model.currentLessonIndex+1].title)")
                            .bold()
                            .foregroundColor(Color(.label))
                            .colorInvert()
                    }
                })
            } else {
                Button(action: {
                    model.currentContentSelection = nil
                }, label: {
                    ZStack {

                        RectangleCard(colour: .green)
                            .frame(height:48)
                        
                        Text("Complete")
                            .bold()
                            .foregroundColor(Color(.label))
                            .colorInvert()
                    }
                })
            }
        }
        .navigationBarTitle(lesson?.title ?? "")
        .padding()
        
        
    }
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
    }
}
