//
//  ContentModel.swift
//  LearningApp
//
//  Created by Uthman Mohamed on 2021-05-01.
//

import Foundation
import Firebase

class ContentModel: ObservableObject {
    
    let db = Firestore.firestore()
    
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
        // Parse style.html
        getLocalStyles()
        
        getModules()
        
        // getRemoteData()
    }
    
    // MARK: - Data Methods
    
    func getLessons(module: Module, completion: @escaping () -> Void) {
        
        let collection = db.collection("modules").document(module.id).collection("lessons")
        
        collection.getDocuments { querySnapshot, error in
            if error == nil && querySnapshot != nil {
                var lessons = [Lesson]()
                
                for document in querySnapshot!.documents {
                    var l = Lesson()
                    
                    l.id = document["id"] as? String ?? UUID().uuidString
                    l.duration = document["duration"] as? String ?? ""
                    l.title = document["title"] as? String ?? ""
                    l.video = document["video"] as? String ?? ""
                    l.explanation = document["explanation"] as? String ?? ""
                    
                    lessons.append(l)
                }
                
                for (index, m) in self.modules.enumerated() {
                    if m.id == module.id {
                        self.modules[index].content.lessons = lessons
                        completion()
                    }
                }
            }
        }
        
    }
    
    func getQuestions(module: Module, completion: @escaping () -> Void) {
        
        let collection = db.collection("modules").document(module.id).collection("questions")
        
        collection.getDocuments { querySnapshot, error in
            if error == nil && querySnapshot != nil {
                var questions = [Question]()
                
                for document in querySnapshot!.documents {
                    var q = Question()
                    
                    q.id = document["id"] as? String ?? UUID().uuidString
                    q.content = document["content"] as? String ?? ""
                    q.correctIndex = document["correctIndex"] as? Int ?? 0
                    q.answers = document["answers"] as? [String] ?? [String]()
                    
                    questions.append(q)
                }
                
                for (index, m) in self.modules.enumerated() {
                    if m.id == module.id {
                        self.modules[index].test.questions = questions
                        completion()
                    }
                }
            }
        }
        
    }
    
    func getModules() {
        
        let collection = db.collection("modules")
        
        collection.getDocuments { querySnapshot, error in
            
            if error == nil && querySnapshot != nil {
                
                var modules = [Module]()
                
                for document in querySnapshot!.documents {
                    
                    var m = Module()
                    
                    m.id = document["id"] as? String ?? UUID().uuidString
                    m.category = document["category"] as? String ?? ""
                    
                    let contentMap = document["content"] as! [String:Any]
                    
                    m.content.id = contentMap["id"] as? String ?? ""
                    m.content.description = contentMap["description"] as? String ?? ""
                    m.content.image = contentMap["image"] as? String ?? ""
                    m.content.time = contentMap["time"] as? String ?? ""
                    
                    let testMap = document["test"] as! [String:Any]
                    
                    m.test.id = testMap["id"] as? String ?? UUID().uuidString
                    m.test.description = testMap["description"] as? String ?? ""
                    m.test.image = testMap["image"] as? String ?? ""
                    m.test.time = testMap["time"] as? String ?? ""
                    
                    modules.append(m)
                    
                }
                
                DispatchQueue.main.async {
                    self.modules = modules
                }
            }
        }
        
    }
    
    func getLocalStyles() {
        
//        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
//
//        guard jsonUrl != nil else { return }
//
//        do {
//
//            let jsonData = try Data(contentsOf: jsonUrl!)
//
//            let myModules = try JSONDecoder().decode([Module].self, from: jsonData)
//
//            self.modules = myModules
//
//        } catch {
//            print(error)
//        }
        
        
        // Parse style data
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        guard styleUrl != nil else {return}
        
        do {
            
            let styleData = try Data(contentsOf: styleUrl!)
            
            self.styleData = styleData
        } catch {
            print(error)
        }
        
    }
    
    func getRemoteData() {
        
        let urlString = "https://1239uth.github.io/LearningApp-Data/data2.json"
        let url = URL(string: urlString)
        
        guard url != nil else { return }
        
        let request = URLRequest(url: url!)
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else { return }
            
            do {
                let modules = try JSONDecoder().decode([Module].self, from: data!)
                
                DispatchQueue.main.async {
                    self.modules += modules
                }
                
            } catch {
                print("Couldn't parse json")
            }
        }.resume()
        
        // dataTask.resume() --> OPTIONAL
        
    }
    
    // MARK: - Module navigation methods
    func beginModule(_ moduleID: String) {
        
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
        guard currentModule != nil else {return false}
        
        return currentLessonIndex + 1 < currentModule!.content.lessons.count
    }
    
    
    func beginTest(_ moduleID: String) {
        
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
