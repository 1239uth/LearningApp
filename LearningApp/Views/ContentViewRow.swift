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
    
    var body: some View {
        let lesson = model.currentModule!.content.lessons[lessonIndex]
        
        ZStack (alignment: .leading) {
            
            RoundedRectangle(cornerRadius: 10)
                .colorInvert()
                .frame(height: 66)
                .shadow(color: Color(.label), radius: 5)
            
            HStack {
                
                Text(String(lessonIndex+1))
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

//struct ContentViewRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentViewRow()
//    }
//}
