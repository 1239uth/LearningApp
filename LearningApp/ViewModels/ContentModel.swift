//
//  ContentModel.swift
//  LearningApp
//
//  Created by Uthman Mohamed on 2021-05-01.
//

import Foundation

class ContentModel: ObservableObject {
    
    @Published var modules: [Module] = [Module]()
    
    @Published var currentModule: Module?
    var currentModuleIndex: Int = 0
    
    var styleData: Data?
    
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
    
    // MARK: Module navigation methods
    func beginModule(_ moduleID: Int) {

        for index in 0..<modules.count {
            if modules[index].id == moduleID {
                self.currentModuleIndex = index
                break
            }
        }
        
        currentModule = modules[currentModuleIndex]
        
    }
}
