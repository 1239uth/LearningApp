//
//  LearningApp.swift
//  LearningApp
//
//  Created by Uthman Mohamed on 2021-05-01.
//

import SwiftUI
import Firebase

@main
struct LearningApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
