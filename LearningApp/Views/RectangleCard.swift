//
//  RectangleCard.swift
//  LearningApp
//
//  Created by Uthman Mohamed on 2021-05-03.
//

import SwiftUI

struct RectangleCard: View {
    
    var colour = Color.white
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(colour)
            .shadow(radius: 5)
    }
}

struct RectangleCard_Previews: PreviewProvider {
    static var previews: some View {
        RectangleCard()
    }
}
