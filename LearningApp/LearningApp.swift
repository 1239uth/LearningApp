//
//  LearningApp.swift
//  LearningApp
//
//  Created by Uthman Mohamed on 2021-05-01.
//

import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
