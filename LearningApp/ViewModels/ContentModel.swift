//
//  ContentModel.swift
//  LearningApp
//
//  Created by Uthman Mohamed on 2021-05-01.
//

import Foundation

class ContentModel: ObservableObject {
    
    @Published var modules = [Module]()
    
    var styleData: Data?
    
    init () {
        
        getLocalData()
        
    }
    
    func getLocalData() {
        
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        //guard jsonUrl != nil else { return }
        
        do {
            
            let jsonData = try Data(contentsOf: jsonUrl!)
            
            let jsonDecoder = JSONDecoder()
            
            let myModules = try jsonDecoder.decode([Module].self, from: jsonData)
            
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
    
}
