//
//  ContentModel.swift
//  LearningApp
//
//  Created by Uthman Mohamed on 2021-05-01.
//

import Foundation

class ContentModel: ObservableObject {
    
    @Published var modules: [Module] = [Module]()
    
    // Current Module
    @Published var currentModule: Module?
    var currentModuleIndex: Int = 0
    
    // Current Lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex: Int = 0
    
    // Current Question
    @Published var currentQuestion: Question?
    var currentQuestionIndex: Int = 0
    
    // Current Lesson Explanation
    @Published var codeText = NSAttributedString()
    
    var styleData: Data?
    
    // Current selection content and test
    @Published var currentContentSelection: Int?
    @Published var currentTestSelection: Int?
    
    init () {
        getLocalData()
    }
    
    
    // MARK: Data Methods
    func getLocalData() {
        
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        guard jsonUrl != nil else { return }
        
        do {
            
            let jsonData = try Data(contentsOf: jsonUrl!)
            
            let myModules = try JSONDecoder().decode([Module].self, from: jsonData)
            
            self.modules = myModules
            
        } catch {
            print(error)
        }
        
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        guard styleUrl != nil else {return}
        
        do {
            
            let styleData = try Data(contentsOf: styleUrl!)
            
            self.styleData = styleData
        } catch {
            print(error)
        }
        
    }
    
    // MARK: - Module navigation methods
    func beginModule(_ moduleID: Int) {
        
        for index in 0..<modules.count {
            if modules[index].id == moduleID {
                self.currentModuleIndex = index
                break
            }
        }
        
        currentModule = modules[currentModuleIndex]
        
    }
    
    
    func beginLesson(_ lessonIndex:Int) {
        
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        } else {
            currentLessonIndex = 0
        }
        
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        codeText = addStyling(currentLesson!.explanation)
        
    }
    
    func nextLesson() {
        currentLessonIndex += 1
        
        if currentLessonIndex < currentModule!.content.lessons.count {
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)
        } else {
            currentLessonIndex = 0
            currentLesson = nil
        }
    }
    
    
    func hasNextLesson() -> Bool {
        return currentLessonIndex + 1 < currentModule!.content.lessons.count
    }
    
    
    func beginTest(_ moduleID: Int) {
        
        beginModule(moduleID)
        
        currentQuestionIndex = 0
        
        if currentModule?.test.questions.count ?? 0 > 0 {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        }
        
    }
    
    func nextQuestion() {
        currentQuestionIndex += 1
        
        if currentQuestionIndex < currentModule!.test.questions.count {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        } else {
            currentQuestionIndex = 0
            currentQuestion = nil
        }
    }
    
    
    // MARK: - Code Styling
    
    private func addStyling(_ htmlString: String) -> NSAttributedString {
        
        var resultString = NSAttributedString()
        var data = Data()
        
        if styleData != nil {
            data.append(self.styleData!)
        }
        
        data.append(Data(htmlString.utf8))
        
        
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            resultString = attributedString
        }
        
        return resultString
        
    }
}
