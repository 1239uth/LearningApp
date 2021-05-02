//
//  HomeViewRow.swift
//  LearningApp
//
//  Created by Uthman Mohamed on 2021-05-02.
//

import SwiftUI

struct HomeViewRow: View {
    
    var image: String
    var title: String
    var description: String
    var count: Int
    var time: String
    
    var body: some View {
        VStack {
            ZStack {
                
                RoundedRectangle(cornerRadius: 10)
                    .colorInvert()
                    .shadow(radius: 10)
                    .aspectRatio(CGSize(width: 335, height: 175), contentMode: .fit)
                
                HStack {
                    Image(image)
                        .resizable()
                        .frame(width: 116, height: 116)
                        .clipShape(Circle())
                    
                    Spacer()
                    
                    VStack (alignment: .leading, spacing: 15) {
                        Text("Learn \(title)")
                            .bold()
                        
                        Text("\(description)")
                            .padding(.bottom, 25)
                            .font(.caption)
                        
                        HStack {
                            
                            Image(systemName: "text.book.closed")
                                .resizable()
                                .frame(width: 15, height: 15)
                            Text("\(count) Lessons")
                                .font(Font.system(size: 10))
                            
                            Image(systemName: "clock")
                                .resizable()
                                .frame(width: 15, height: 15)
                            Text("\(time)")
                                .font(.caption)
                            
                        }
                    }
                    .padding(.leading, 20)
                }
                .padding(.horizontal)
                
            }
        }
    }
}

struct HomeViewRow_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewRow(image: "swift", title: "Learn Swift", description: "some description", count: 10, time: "2 Hours")
    }
}
